import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_add_outlet_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class RegisterBrandPage extends StatelessWidget {
  RegisterBrandPage({super.key});
  final _formKey = GlobalKey<FormState>();
  TextEditingController receiptPhone = TextEditingController();
  TextEditingController receiptBrand = TextEditingController();
  TextEditingController receiptMessage = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Informasi Brand")),
      drawer: DrawerAdmin(active: 15, size: size),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              if (_formKey.currentState!.validate()) {
                var pref = await SharedPreferences.getInstance();
                await pref.setString('temp_register_receipt_phone', receiptPhone.text);
                await pref.setString('temp_register_receipt_brand', receiptBrand.text);
                await pref.setString('temp_register_receipt_message', receiptMessage.text);
              }
            },
            child: const Text("Simpan")),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
          future: Services.getUserInformation(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
            receiptPhone.text = snapshot.data['data'][0]['receipt_phone'];
            receiptBrand.text = snapshot.data['data'][0]['receipt_brand'];
            receiptMessage.text = snapshot.data['data'][0]['receipt_message'];
            return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    TextFormField(
                      controller: receiptPhone,
                      validator: validate,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(labelText: 'Call Center', icon: Icon(Icons.phone)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: receiptBrand,
                      validator: validate,
                      decoration: const InputDecoration(labelText: 'Nama Brand', icon: Icon(Icons.store)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: receiptMessage,
                      validator: validate,
                      decoration: const InputDecoration(labelText: 'Pesan Brand', icon: Icon(Icons.message)),
                    ),
                  ],
                ));
          }),
    );
  }

  String? validate(value) {
    if (value!.isEmpty) {
      return "Kolom tidak boleh kosong";
    } else {
      return null;
    }
  }
}
