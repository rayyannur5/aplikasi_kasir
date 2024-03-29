import 'dart:io';

import 'package:aplikasi_kasir/pages/auth/pegawai_refferal_page.dart';
import 'package:aplikasi_kasir/pages/auth/register_brand_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin_manajemen/manajemen_add_outlet_page.dart';

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({super.key, required this.dataDevice});
  final Map dataDevice;
  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  String? path;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto Profil')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: path == null ? const Icon(Icons.account_circle_rounded, size: 200) : ClipOval(child: Image.file(File(path!), fit: BoxFit.cover)),
            ),
            TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
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
                                    pop(context);
                                    setState(() {
                                      path = image.path;
                                    });
                                  }
                                }),
                            ListTile(
                                title: const Text("Kamera"),
                                onTap: () async {
                                  await Future.delayed(const Duration(milliseconds: 200));
                                  final XFile? image = await picker.pickImage(source: ImageSource.camera, maxHeight: 640, maxWidth: 480);
                                  if (image != null) {
                                    pop(context);
                                    setState(() {
                                      path = image.path;
                                    });
                                  }
                                }),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Pilih Foto')),
            const Spacer(),
            ElevatedButton(
                onPressed: path == null
                    ? null
                    : () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        var pref = await SharedPreferences.getInstance();
                        await pref.setString('temp_register_profile_picture', path!);

                        if (pref.getString('register_mode') == 'admin') {
                          push(context, AddOutletPage(dataDevice: widget.dataDevice));
                        } else {
                          push(context, InputKodeRefferalPage());
                        }
                      },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      } else {
                        return Theme.of(context).primaryColor;
                      }
                    },
                  ),
                ),
                child: const Text('Lanjutkan')),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () async {
                  var pref = await SharedPreferences.getInstance();

                  final byteData = await rootBundle.load('assets/images/profile.png');

                  final file = File('${(await getTemporaryDirectory()).path}/profile.png');
                  await file.create(recursive: true);
                  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
                  print(file.path);
                  await pref.setString('temp_register_profile_picture', file.path);

                  if (pref.getString('register_mode') == 'admin') {
                    push(context, AddOutletPage(dataDevice: widget.dataDevice));
                  } else {
                    push(context, InputKodeRefferalPage());
                  }
                },
                child: const Text("Lewati")),
          ],
        ),
      ),
    );
  }
}
