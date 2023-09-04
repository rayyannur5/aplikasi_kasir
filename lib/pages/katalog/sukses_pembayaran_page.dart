import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:aplikasi_kasir/pages/print_page/detail_transaksi_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuksesPembayaranPage extends StatelessWidget {
  const SuksesPembayaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran Berhasil', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            LottieBuilder.asset('assets/lotties/success.json'),
            const Spacer(),
            ElevatedButton(
                onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => push(context, const DetailTransaksi(id: '1'))),
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff449DD1))),
                child: const Text('Cetak')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  var loginData = await Local.getLogin();
                  if (loginData['role'] == 'admin') {
                    pushAndRemoveUntil(context, KatalogPage(role: 'admin'));
                  } else {
                    pushAndRemoveUntil(context, KatalogPage(role: 'user'));
                  }
                },
                child: const Text('Kembali')),
          ],
        ),
      ),
    );
  }
}
