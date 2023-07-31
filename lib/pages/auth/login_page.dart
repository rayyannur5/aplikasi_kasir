// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/auth/register_page.dart';
import 'package:aplikasi_kasir/pages/admin_dashboard/dashboard_page.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool headervisible = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  _LoginPageState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        headervisible = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            header(),
            const SizedBox(height: 50),
            form(size),
          ],
        ),
      ),
    );
  }

  Container form(Size size) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      height: size.height - 300,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Column(
        children: [
          Text('Masukkan email dan password', style: TextStyles.h3),
          const SizedBox(height: 30),
          TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 20),
          TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 200), login);
              },
              child: const Text('Login')),
          const Spacer(),
          TextButton(
              onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pushReplacementFromBottom(context, const RegisterPage())),
              child: Text('Apakah Belum Punya Akun ? Daftar', style: TextStyles.pBold)),
        ],
      ),
    );
  }

  login() async {
    if (email.text.isEmpty) {
      showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => CupertinoAlertDialog(content: const Text('Kolom Email Harus Diisi'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
      return;
    } else if (password.text.isEmpty) {
      showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => CupertinoAlertDialog(content: const Text('Kolom Password Harus Diisi'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
      return;
    }
    showDialog(context: context, barrierDismissible: false, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
    bool response = await Services.login(email.text, password.text);
    if (response) {
      var user = await Local.getUserData();
      if (user['user_role'] == 'admin') {
        pushAndRemoveUntil(context, const DashboardPage());
      } else {
        pushAndRemoveUntil(context, KatalogPage());
      }
    } else {
      pop(context);
      showDialog(context: context, builder: (context) => Dialog(child: Padding(padding: const EdgeInsets.all(30), child: Text('Login Gagal', textAlign: TextAlign.center, style: TextStyles.pBold))));
      return;
    }
  }

  AnimatedOpacity header() {
    return AnimatedOpacity(
      opacity: headervisible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Column(
          children: [
            Text('Masuk Akun Saya', style: TextStyles.h1Light),
            Image.asset('assets/images/logo.png'),
          ],
        ),
      ),
    );
  }
}
