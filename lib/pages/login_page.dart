import 'package:aplikasi_kasir/pages/register_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool headervisible = false;

  _LoginPageState() {
    Future.delayed(Duration(milliseconds: 300), () {
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
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 20),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password')),
          const SizedBox(height: 50),
          ElevatedButton(onPressed: () {}, child: Text('Login')),
          Spacer(),
          TextButton(
              onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pushReplacementFromBottom(context, const RegisterPage())),
              child: Text('Apakah Belum Punya Akun ? Daftar', style: TextStyles.pBold)),
        ],
      ),
    );
  }

  AnimatedOpacity header() {
    return AnimatedOpacity(
      opacity: headervisible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
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
