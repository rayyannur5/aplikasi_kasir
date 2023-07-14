import 'package:aplikasi_kasir/pages/auth/register_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'login_page.dart';

// ignore: must_be_immutable
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            children: [
              page1(size),
              page2(),
              page3(context, size),
            ],
          ),
          indikator()
        ],
      ),
    );
  }

  Container page3(BuildContext context, size) => Container(
        padding: const EdgeInsets.all(50),
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text('Cetak transaksi dengan printer bluetooth', textAlign: TextAlign.center, style: TextStyles.h2Light),
            LottieBuilder.asset('assets/lotties/bill.json'),
            const Spacer(flex: 1),
            ElevatedButton(
              onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pushFromBottom(context, const LoginPage())),
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff449DD1))),
              child: const Text('Masuk'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pushFromBottom(context, const RegisterPage())),
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff3943B7))),
              child: const Text('Daftar'),
            )
          ],
        ),
      );

  Container page2() => Container(
        padding: const EdgeInsets.all(50),
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/boarding 2.png'), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hubungkan perangkat IOT dengan scan QR', textAlign: TextAlign.center, style: TextStyles.h2Light),
            Image.asset('assets/images/pic-boarding 2.png'),
          ],
        ),
      );

  Container page1(Size size) => Container(
        padding: const EdgeInsets.all(50),
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/boarding 1.png'), fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: size.width / 4),
              child: Text('Selamat Datang di Aplikasi Kasir', style: TextStyles.h1),
            ),
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 30),
            Text('Lakukan transaksimu dan manajemen petugas', textAlign: TextAlign.center, style: TextStyles.h2),
            Image.asset('assets/images/pic-boarding 1.png'),
          ],
        ),
      );

  Container indikator() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(2),
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: currentIndex == 0 ? const Color(0xff78C0E0) : const Color(0xffD9D9D9), shape: BoxShape.circle),
          ),
          Container(
            margin: const EdgeInsets.all(2),
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: currentIndex == 1 ? const Color(0xff78C0E0) : const Color(0xffD9D9D9), shape: BoxShape.circle),
          ),
          Container(
            margin: const EdgeInsets.all(2),
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: currentIndex == 2 ? const Color(0xff78C0E0) : const Color(0xffD9D9D9), shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
