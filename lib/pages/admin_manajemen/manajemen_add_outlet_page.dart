import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_outlet_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AddOutletPage extends StatelessWidget {
  AddOutletPage({super.key, required this.dataDevice});
  final Map dataDevice;
  final TextEditingController nama = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Outlet/Cabang', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
              child: Text('ID Device       : ${dataDevice['id']}'),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
              child: Text('Nama Device : ${dataDevice['nama']}', style: const TextStyle(overflow: TextOverflow.ellipsis)),
            ),
            const TextField(decoration: InputDecoration(labelText: 'Nama Outlet')),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
                  await Services.addOutlet(dataDevice, nama.text);
                  pushAndRemoveUntil(context, ManajemenOutletPage());
                },
                child: const Text('Tambah')),
          ],
        ),
      ),
    );
  }
}
