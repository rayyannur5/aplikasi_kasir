import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_shift_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AddShiftPage extends StatefulWidget {
  const AddShiftPage({super.key, this.id = '0', required this.nama, required this.start, required this.end});
  final String id;
  final String start;
  final String end;
  final String nama;

  @override
  State<AddShiftPage> createState() => _AddShiftPageState();
}

class _AddShiftPageState extends State<AddShiftPage> {
  TimeOfDay? start;
  TimeOfDay? end;
  TextEditingController nama = TextEditingController();

  @override
  void initState() {
    var startt = widget.start.split(':');
    start = TimeOfDay(hour: int.parse(startt[0]), minute: int.parse(startt[1]));
    var endd = widget.end.split(':');
    end = TimeOfDay(hour: int.parse(endd[0]), minute: int.parse(endd[1]));
    // start = Timeo
    nama.text = widget.nama;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == '0' ? 'Tambah Shift' : 'Ubah Shift', style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: nama, decoration: const InputDecoration(labelText: 'Nama Shift')),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: size.width / 2 - 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Waktu Mulai', style: TextStyles.h3),
                        Card(
                            child: ListTile(
                          title: Text(start!.format(context), style: TextStyles.h1),
                          onTap: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            start = await showTimePicker(context: context, initialTime: start!);
                            print(start);
                            setState(() {});
                          },
                        )),
                      ],
                    )),
                SizedBox(
                    width: size.width / 2 - 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Waktu Berakhir', style: TextStyles.h3),
                        Card(
                            child: ListTile(
                          title: Text(end!.format(context), style: TextStyles.h1),
                          onTap: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            end = await showTimePicker(context: context, initialTime: end!);
                            print(end);
                            setState(() {});
                          },
                        )),
                      ],
                    )),
              ],
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  if (nama.text.isEmpty) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        content: const Text("Nama Tidak Boleh Kosong"),
                        actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))],
                      ),
                    );
                    return;
                  }
                  await Future.delayed(const Duration(milliseconds: 200));
                  // ignore: use_build_context_synchronously
                  showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
                  if (widget.id == '0') {
                    await Services.addShift(nama.text, start!.format(context), end!.format(context));
                  } else {
                    await Services.updateShift(nama.text, start!.format(context), end!.format(context));
                  }
                  // ignore: use_build_context_synchronously
                  pushAndRemoveUntil(context, const ManajemenShiftPage());
                },
                child: Text(widget.id == '0' ? 'Tambah' : 'Simpan')),
          ],
        ),
      ),
    );
  }
}
