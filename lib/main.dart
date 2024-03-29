import 'dart:io';

import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/user_information.dart';
import 'package:aplikasi_kasir/pages/account_hold_page.dart';
import 'package:aplikasi_kasir/pages/admin_dashboard/dashboard_page.dart';
import 'package:aplikasi_kasir/pages/auth/onboarding_page.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/auth/not_verified_page.dart';

void main() async {
  // runApp(MyApp());
  await initializeDateFormatting('id_ID', null);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final Map<int, Color> color = {
    50: const Color.fromRGBO(4, 131, 184, .1),
    100: const Color.fromRGBO(4, 131, 184, .2),
    200: const Color.fromRGBO(4, 131, 184, .3),
    300: const Color.fromRGBO(4, 131, 184, .4),
    400: const Color.fromRGBO(4, 131, 184, .5),
    500: const Color.fromRGBO(4, 131, 184, .6),
    600: const Color.fromRGBO(4, 131, 184, .7),
    700: const Color.fromRGBO(4, 131, 184, .8),
    800: const Color.fromRGBO(4, 131, 184, .9),
    900: const Color.fromRGBO(4, 131, 184, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xff0E0E52),
          foregroundColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff0E0E52),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 20, fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(50)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          elevation: const MaterialStatePropertyAll(10),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5)),
          backgroundColor: const MaterialStatePropertyAll(Color(0xff0E0E52)),
        )),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          fillColor: const Color(0xffECECEC),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff8E8E8E)),
        ),
        fontFamily: 'Montserrat',
        primaryColor: const Color(0xff0E0E52),
        primarySwatch: MaterialColor(0xff0E0E52, color),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0E0E52)),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: getUserInformationAndLogin(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
            if (snapshot.data!['value']) {
              if (snapshot.data!['data'][0]['role'] == 'admin') {
                return const DashboardPage();
              } else {
                if (snapshot.data!['data'][0]['active'] == '0') {
                  return NotVerifiedPage();
                }
                return KatalogPage(role: 'user');
              }
            } else {
              return const OnBoardingPage();
            }
          }),
    );
  }

  Future getUserInformationAndLogin() async {
    var tempDir = await getTemporaryDirectory();

    final dir = Directory(tempDir.path);
    dir.deleteSync(recursive: true);

    await UserInformation.delete();
    var login = await Local.getLogin();
    var userInformation = await UserInformation.get();
    userInformation['value'] = login['value'];

    return userInformation;
  }
}
