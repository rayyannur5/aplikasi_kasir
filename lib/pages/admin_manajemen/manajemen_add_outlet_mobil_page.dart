import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_dashboard/dashboard_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_outlet_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManajemenAddOutletMobilPage extends StatefulWidget {
  const ManajemenAddOutletMobilPage({super.key});

  @override
  State<ManajemenAddOutletMobilPage> createState() => _ManajemenAddOutletMobilPageState();
}

class _ManajemenAddOutletMobilPageState extends State<ManajemenAddOutletMobilPage> {
  TextEditingController tambahAnginMobil = TextEditingController();

  TextEditingController isiBaruMobil = TextEditingController();

  TextEditingController tambalBanMobil = TextEditingController();

  TextEditingController pasMobil = TextEditingController(text: '0');

  TextEditingController errorMobil = TextEditingController(text: '0');

  TextEditingController kurangiMobil = TextEditingController(text: '0');

  TextEditingController pauseMobil = TextEditingController(text: '0');

  bool valuePasMobil = false;
  bool valueKurangiMobil = false;
  bool valuePauseMobil = false;
  bool valueErrorMobil = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mobil")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));

                var pref = await SharedPreferences.getInstance();
                await pref.setString("temp_add_outlet_device_product_2", tambahAnginMobil.text);
                await pref.setString("temp_add_outlet_device_product_4", isiBaruMobil.text);
                await pref.setString("temp_add_outlet_device_product_6", tambalBanMobil.text);
                await pref.setString("temp_add_outlet_device_product_8", pasMobil.text);
                await pref.setString("temp_add_outlet_device_product_10", kurangiMobil.text);
                await pref.setString("temp_add_outlet_device_product_12", pauseMobil.text);
                await pref.setString("temp_add_outlet_device_product_14", errorMobil.text);

                bool isLogin = pref.getBool('is_login') ?? false;
                if (isLogin) {
                  var createStoresResp = await Services().addOutlet();
                  if (createStoresResp['success']) {
                    pushAndRemoveUntil(context, ManajemenOutletPage());
                  } else {
                    pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(createStoresResp['errors'])));
                  }
                } else {
                  var registerResp = await Services().register();
                  if (registerResp['success']) {
                    var createStoresResp = await Services().addOutlet();
                    if (createStoresResp['success']) {
                      pushAndRemoveUntil(context, const DashboardPage());
                    } else {
                      pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(createStoresResp['errors'])));
                    }
                  } else {
                    pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(registerResp['errors'])));
                  }
                }
              }
            },
            child: const Text("Lanjutkan")),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: tambahAnginMobil,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value!.isEmpty || value == '0') {
                  return "Harga Tidak boleh kosong";
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (_) {
                if (valuePasMobil) {
                  pasMobil.text = _;
                }
                if (valueKurangiMobil) {
                  kurangiMobil.text = _;
                }
                if (valuePauseMobil) {
                  pauseMobil.text = _;
                }
                if (valueErrorMobil) {
                  errorMobil.text = _;
                }
              },
              decoration: InputDecoration(
                icon: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/mobil-2.png')),
                labelText: "HARGA TAMBAH ANGIN MOBIL",
                filled: false,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: isiBaruMobil,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value!.isEmpty || value == '0') {
                  return "Harga Tidak boleh kosong";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                icon: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/mobil-2.png')),
                labelText: "HARGA ISI BARU MOBIL",
                filled: false,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: tambalBanMobil,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value!.isEmpty || value == '0') {
                  return "Harga Tidak boleh kosong";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                icon: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/mobil-2.png')),
                labelText: "HARGA TAMBAL BAN MOBIL",
                filled: false,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Apabila layanan dibawah ini diaktifkan, maka harga akan sesuai dengan TAMBAH ANGIN Mobil", style: TextStyle(color: Colors.grey)),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/mobil-2.png')),
                  title: const Text("PASS MOBIL", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valuePasMobil,
                  onChanged: (value) {
                    setState(() {
                      valuePasMobil = value;
                      if (value) {
                        pasMobil.text = tambahAnginMobil.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: pasMobil,
                  enabled: !valuePasMobil,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA PASS MOBIL"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/mobil-2.png')),
                  title: const Text("KURANGI MOBIL", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valueKurangiMobil,
                  onChanged: (value) {
                    setState(() {
                      valueKurangiMobil = value;
                      if (value) {
                        kurangiMobil.text = tambahAnginMobil.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: kurangiMobil,
                  enabled: !valueKurangiMobil,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA KURANGI MOBIL"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/mobil-2.png')),
                  title: const Text("PAUSE MOBIL", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valuePauseMobil,
                  onChanged: (value) {
                    setState(() {
                      valuePauseMobil = value;
                      if (value) {
                        pauseMobil.text = tambahAnginMobil.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: pauseMobil,
                  enabled: !valuePauseMobil,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA PAUSE MOBIL"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/mobil-2.png')),
                  title: const Text("ERROR MOBIL", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valueErrorMobil,
                  onChanged: (value) {
                    setState(() {
                      valueErrorMobil = value;
                      if (value) {
                        errorMobil.text = tambahAnginMobil.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: errorMobil,
                  enabled: !valueErrorMobil,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA ERROR MOBIL"),
                )
              ],
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
