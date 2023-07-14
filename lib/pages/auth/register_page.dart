import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool headervisible = false;

  _RegisterPageState() {
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
            const SizedBox(height: 70),
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
          Text('Isi data diri sesuai dengan form yang dibutuhkan', style: TextStyles.h3),
          const SizedBox(height: 30),
          const TextField(decoration: InputDecoration(labelText: 'Nama')),
          const SizedBox(height: 20),
          const TextField(decoration: InputDecoration(labelText: 'Email')),
          const SizedBox(height: 20),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password')),
          const SizedBox(height: 50),
          ElevatedButton(onPressed: () {}, child: const Text('Login')),
          const Spacer(),
          TextButton(
              onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pushReplacementFromBottom(context, const LoginPage())),
              child: Text('Apakah Sudah Punya Akun ? Masuk', style: TextStyles.pBold)),
        ],
      ),
    );
  }

  AnimatedOpacity header() {
    return AnimatedOpacity(
      opacity: headervisible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: double.infinity,
        height: 180,
        child: Column(
          children: [
            Text('Daftarkan Diri Anda', style: TextStyles.h1Light),
            const Text(
              'untuk mendapatkan tawaran menarik dari kami',
              style: TextStyle(color: Colors.white),
            ),
            Image.asset('assets/images/logo.png'),
          ],
        ),
      ),
    );
  }
}
