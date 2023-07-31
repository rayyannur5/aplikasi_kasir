import 'package:aplikasi_kasir/pages/auth/qr_scan_awal_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool headervisible = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isEmail(String em) {
    RegExp regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return regExp.hasMatch(em);
  }

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
            const SizedBox(height: 30),
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
        height: size.height - 150,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        child: Column(
          children: [
            Text('Isi data diri sesuai dengan form yang dibutuhkan', style: TextStyles.h3),
            const SizedBox(height: 30),
            TextFormField(
                controller: name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kolom tidak boleh kosong";
                  } else if (value.length < 5) {
                    return "Banyak huruf kurang dari 5";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: 'Nama')),
            const SizedBox(height: 20),
            TextFormField(
                controller: phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kolom tidak boleh kosong";
                  } else if (value.length < 9) {
                    return "Banyak huruf kurang dari 9";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Telepon')),
            const SizedBox(height: 20),
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
                keyboardType: TextInputType.emailAddress,
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
                onPressed: () async {
                  Future.delayed(const Duration(milliseconds: 200));
                  if (_formKey.currentState!.validate()) {
                    var pref = await SharedPreferences.getInstance();
                    await pref.setString("temp_register_name", name.text);
                    await pref.setString("temp_register_email", email.text);
                    await pref.setString("temp_register_phone", phone.text);
                    await pref.setString("temp_register_password", password.text);
                    push(context, ScanQRAwalPage());
                  }
                },
                child: const Text('Daftar')),
            TextButton(
                onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pushReplacementFromBottom(context, const LoginPage())),
                child: Text('Apakah Sudah Punya Akun ? Masuk', style: TextStyles.pBold)),
          ],
        ),
      ),
    );
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
