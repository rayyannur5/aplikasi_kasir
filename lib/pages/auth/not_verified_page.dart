import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/material.dart';

class NotVerifiedPage extends StatelessWidget {
  const NotVerifiedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/waiting.png'),
            Text(
              'Akun anda belum diverifikasi, Tunggu admin untuk memverifikasi!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  var userData = await Services.getUserInformation();
                  if (userData['success'] && userData['data'][0]['active'] == '1') {
                    pushAndRemoveUntil(context, KatalogPage(role: 'user'));
                  }
                },
                child: Text('Refresh'))
          ],
        ),
      ),
    );
  }
}
