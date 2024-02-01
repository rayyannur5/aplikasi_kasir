import 'dart:io';

import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_dashboard/dashboard_page.dart';
import 'package:aplikasi_kasir/pages/auth/onboarding_page.dart';
import 'package:aplikasi_kasir/pages/payment_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/local.dart';
import '../api/user_information.dart';

class AccountHold extends StatelessWidget {
  AccountHold(this.role, {super.key});
  final String role;
  var clickPembayaran = false;
  var clickRefresh = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/warning.webp'),
              const SizedBox(height: 10),
              Text(role == 'admin' ? 'Akun anda ditangguhkan, Silahkan selesaikan pembayaran untuk menggunakan aplikasi' : 'Akun anda ditangguhkan karena admin belum melakukan pembayaran aplikasi',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              role == 'admin'
                  ? StatefulBuilder(builder: (context, state) {
                      return ElevatedButton(
                          onPressed: clickPembayaran
                              ? null
                              : () async {
                                  state(() => clickPembayaran = true);
                                  var pref = await SharedPreferences.getInstance();
                                  state(() => clickPembayaran = false);
                                  if (!pref.containsKey('snap_token')) {
                                    var snap = await Services.getSnapToken(1);
                                    if (snap['success']) {
                                      await pref.setString('snap_token', snap['data']);
                                      push(context, PaymentPage(snapToken: snap['data']));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snap['errors'])));
                                    }
                                  } else {
                                    state(() => clickPembayaran = false);
                                    String snapToken = pref.getString('snap_token')!;
                                    print(snapToken);
                                    push(context, PaymentPage(snapToken: snapToken));
                                  }
                                },
                          child: clickPembayaran ? CupertinoActivityIndicator(color: Colors.white) : Text('Pembayaran'));
                    })
                  : const SizedBox(),
              const SizedBox(height: 10),
              role == 'admin'
                  ? StatefulBuilder(builder: (context, state) {
                      return ElevatedButton(
                          onPressed: clickRefresh
                              ? null
                              : () async {
                                  state(() => clickRefresh = true);
                                  var user = await Services.getUserInformation();
                                  print(user);
                                  state(() => clickRefresh = false);
                                  if (user['data'][0]['active'] == '1') {
                                    pushAndRemoveUntil(context, DashboardPage());
                                  }
                                },
                          child: clickRefresh ? CupertinoActivityIndicator(color: Colors.white) : Text('Refresh Halaman'));
                    })
                  : const SizedBox(),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Apakah anda yakin untuk logout?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      var tempDir = await getTemporaryDirectory();

                                      final dir = Directory(tempDir.path);
                                      dir.deleteSync(recursive: true);
                                      await UserInformation.delete();
                                      var resp = await Local.userLogout();
                                      if (resp) {
                                        pushAndRemoveUntil(context, const OnBoardingPage());
                                      } else {
                                        pop(context);
                                      }
                                    },
                                    child: const Text('Logout')),
                                TextButton(onPressed: () => pop(context), child: const Text('Batal'))
                              ],
                            ));
                  },
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  child: Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}
