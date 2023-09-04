import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/auth/not_verified_page.dart';
import 'package:aplikasi_kasir/pages/auth/qr_scan_refferal_page.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputKodeRefferalPage extends StatelessWidget {
  InputKodeRefferalPage({super.key});

  final TextEditingController refferal = TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kode Refferal')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: StatefulBuilder(builder: (context, setstate) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_form.currentState!.validate()) {
                        setstate(() {
                          _isLoading = true;
                        });
                        var pref = await SharedPreferences.getInstance();
                        await pref.setString('temp_refferal', refferal.text);

                        await Future.delayed(const Duration(milliseconds: 200));

                        var res = await Services().register();
                        setstate(() {
                          _isLoading = false;
                        });
                        if (res['success']) {
                          pushAndRemoveUntil(context, NotVerifiedPage());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                        }
                      }
                    },
              child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)) : const Text('Lanjutkan')),
        );
      }),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: TextFormField(
                          controller: refferal,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom ini harus diisi";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Kode Refferal'))),
                  Expanded(
                      child: IconButton(
                          onPressed: () async {
                            var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => QRRefferal()));
                            refferal.text = res;
                          },
                          tooltip: 'Scan Kode',
                          icon: const Icon(Icons.qr_code))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
