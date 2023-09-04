import 'dart:io';

import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../api/local.dart';
import '../../api/user_information.dart';
import 'onboarding_page.dart';

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
                child: Text('Refresh')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
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
                    ),
                  );
                },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
