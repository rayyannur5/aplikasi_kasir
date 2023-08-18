// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/auth/not_verified_page.dart';
import 'package:aplikasi_kasir/pages/auth/register_page.dart';
import 'package:aplikasi_kasir/pages/admin_dashboard/dashboard_page.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
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
  final _formKey = GlobalKey<FormState>();

  _LoginPageState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        headervisible = true;
      });
    });
  }

  bool isEmail(String em) {
    RegExp regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return regExp.hasMatch(em);
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

  Form form(Size size) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        height: size.height - 300,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Column(
          children: [
            Text('Masukkan email dan password', style: TextStyles.h3),
            const SizedBox(height: 30),
            TextFormField(
                controller: email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kolom tidak boleh kosong";
                  } else if (!isEmail(value)) {
                    return "Email tidak valid";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            TextFormField(
                controller: password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kolom tidak boleh kosong";
                  } else if (value.length < 4) {
                    return "Banyak karakter password kurang dari 4";
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')),
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
      ),
    );
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
      Map response = await Services.login(email.text, password.text);
      if (response['success']) {
        var userData = await Local.getUserData();
        if (userData['user_role'] == 'admin') {
          pushAndRemoveUntil(context, const DashboardPage());
        } else {
          if (response['data'][0]['active'] == '1') {
            pushAndRemoveUntil(context, KatalogPage());
          } else {
            pushAndRemoveUntil(context, const NotVerifiedPage());
          }
        }
      } else {
        pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['errors'])));
        return;
      }
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
