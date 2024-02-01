import 'dart:io';

import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/api/user_information.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/petugas_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_page.dart';

class ProfilPenggunaPage extends StatelessWidget {
  ProfilPenggunaPage({super.key});
  bool isKirim = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      drawer: FutureBuilder(
          future: Local.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox();
            if (snapshot.data!['user_role'] == 'admin') {
              return DrawerAdmin(size: size, active: 12);
            }
            return DrawerPetugas(size: size, active: 6);
          }),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
            future: UserInformation.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
              var data = snapshot.data!['data'][0];
              return Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ClipOval(
                      child: Image.network(data['profile_picture']),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                    title: const Text("Galeri"),
                                    onTap: () async {
                                      await Future.delayed(const Duration(milliseconds: 200));
                                      final XFile? image = await picker.pickImage(source: ImageSource.gallery, maxHeight: 640, maxWidth: 480);
                                      if (image != null) {
                                        bool pressed = false;
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) => CupertinoAlertDialog(
                                            title: Text('Preview Gambar'),
                                            content: SizedBox(
                                              height: 100,
                                              child: Image.file(File(image.path)),
                                            ),
                                            actions: [
                                              StatefulBuilder(builder: (context, setstate) {
                                                return TextButton(
                                                    onPressed: pressed
                                                        ? null
                                                        : () async {
                                                            setstate(() => pressed = true);
                                                            var res = await Services.updatePhotos(image.path);
                                                            setstate(() => pressed = false);
                                                            if (res['success']) {
                                                              await UserInformation.delete();
                                                              var pref = await SharedPreferences.getInstance();
                                                              pref.setString('user_profile_picture', res['data']);
                                                              pushAndRemoveUntil(context, ProfilPenggunaPage());
                                                            } else {
                                                              showCupertinoDialog(
                                                                context: context,
                                                                builder: (context) => CupertinoAlertDialog(
                                                                  content: Text(res['errors']),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => pop(context),
                                                                      child: Text('OK'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                          },
                                                    child: pressed ? CupertinoActivityIndicator() : Text('Simpan'));
                                              }),
                                              TextButton(onPressed: () => pop(context), child: Text('Batal')),
                                            ],
                                          ),
                                        );
                                      }
                                    }),
                                ListTile(
                                    title: const Text("Kamera"),
                                    onTap: () async {
                                      await Future.delayed(const Duration(milliseconds: 200));
                                      final XFile? image = await picker.pickImage(source: ImageSource.camera, maxHeight: 640, maxWidth: 480);
                                      if (image != null) {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) => CupertinoAlertDialog(
                                            title: Text('Preview Gambar'),
                                            content: SizedBox(
                                              height: 100,
                                              child: Image.file(File(image.path)),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text('Ubah Foto Profil')),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: data['name']),
                    decoration: InputDecoration(
                        labelText: 'Nama',
                        suffixIcon: IconButton(
                            onPressed: () {
                              var name = TextEditingController(text: data['name']);
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: name,
                                        decoration: const InputDecoration(labelText: 'Nama'),
                                      ),
                                      const SizedBox(height: 20),
                                      StatefulBuilder(builder: (context, setstate) {
                                        return ElevatedButton(
                                            onPressed: isKirim
                                                ? null
                                                : () async {
                                                    if (name.text.isEmpty) {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) => CupertinoAlertDialog(
                                                          content: Text('Nama harus diisi'),
                                                          actions: [TextButton(onPressed: () => pop(context), child: Text('Ok'))],
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                    setstate(() => isKirim = false);
                                                    var response = await Services.updateName(name.text);
                                                    if (response['success']) {
                                                      await UserInformation.delete();
                                                      pushAndRemoveUntil(context, ProfilPenggunaPage());
                                                    } else {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) => CupertinoAlertDialog(
                                                          content: Column(
                                                            children: [
                                                              Image.asset('assets/images/error.png', scale: 2),
                                                              Text(response['errors']),
                                                            ],
                                                          ),
                                                          actions: [TextButton(onPressed: () => pop(context), child: Text('Ok'))],
                                                        ),
                                                      );
                                                      setstate(() => isKirim = false);
                                                    }
                                                  },
                                            child: isKirim ? const CupertinoActivityIndicator(color: Colors.white) : const Text('Simpan'));
                                      }),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit))),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: data['role']),
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: data['email']),
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: data['phone']),
                    decoration: const InputDecoration(labelText: 'No Telp'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: "*****"),
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              var passwordlama = TextEditingController();
                              var passwordBaru = TextEditingController();
                              var passwordBaruUlang = TextEditingController();
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      TextField(
                                        controller: passwordlama,
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Password Lama'),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: passwordBaru,
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Password Baru'),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: passwordBaruUlang,
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Ketik Ulang Password Baru'),
                                      ),
                                      const SizedBox(height: 20),
                                      StatefulBuilder(builder: (context, setstate) {
                                        return ElevatedButton(
                                            onPressed: isKirim
                                                ? null
                                                : () async {
                                                    if (passwordBaru.text.isEmpty || passwordlama.text.isEmpty || passwordBaruUlang.text.isEmpty) {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) => CupertinoAlertDialog(
                                                          content: Text('Semua kolom harus diisi'),
                                                          actions: [TextButton(onPressed: () => pop(context), child: Text('Ok'))],
                                                        ),
                                                      );
                                                      return;
                                                    } else if (passwordBaru.text != passwordBaruUlang.text) {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) => CupertinoAlertDialog(
                                                          content: Text('Ketik ulang password salah'),
                                                          actions: [TextButton(onPressed: () => pop(context), child: Text('Ok'))],
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                    setstate(() => isKirim = true);
                                                    var response = await Services.updatePassword(passwordlama.text, passwordBaru.text);
                                                    if (response['success']) {
                                                      pushAndRemoveUntil(context, ProfilPenggunaPage());
                                                    } else {
                                                      showCupertinoDialog(
                                                        context: context,
                                                        builder: (context) => CupertinoAlertDialog(
                                                          content: Column(
                                                            children: [
                                                              Image.asset('assets/images/error.png', scale: 2),
                                                              Text(response['errors']),
                                                            ],
                                                          ),
                                                          actions: [TextButton(onPressed: () => pop(context), child: Text('Ok'))],
                                                        ),
                                                      );
                                                      setstate(() => isKirim = false);
                                                    }
                                                  },
                                            child: isKirim ? const CupertinoActivityIndicator(color: Colors.white) : const Text('Simpan'));
                                      }),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit))),
                  ),
                  const Spacer(),
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
                          ),
                        );
                      },
                      child: const Text('Logout')),
                ],
              );
            }),
      ),
    );
  }
}
