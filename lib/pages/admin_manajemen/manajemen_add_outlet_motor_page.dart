import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_add_outlet_mobil_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManajemenAddOutletMotorPage extends StatefulWidget {
  const ManajemenAddOutletMotorPage({super.key});

  @override
  State<ManajemenAddOutletMotorPage> createState() => _ManajemenAddOutletMotorPageState();
}

class _ManajemenAddOutletMotorPageState extends State<ManajemenAddOutletMotorPage> {
  TextEditingController tambahAnginMotor = TextEditingController();

  TextEditingController isiBaruMotor = TextEditingController();

  TextEditingController tambalBanMotor = TextEditingController();

  TextEditingController pasMotor = TextEditingController(text: '0');

  TextEditingController errorMotor = TextEditingController(text: '0');

  TextEditingController kurangiMotor = TextEditingController(text: '0');

  TextEditingController pauseMotor = TextEditingController(text: '0');

  bool valuePasMotor = false;
  bool valueKurangiMotor = false;
  bool valuePauseMotor = false;
  bool valueErrorMotor = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Motor")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              if (_formKey.currentState!.validate()) {
                var pref = await SharedPreferences.getInstance();
                await pref.setString("temp_add_outlet_device_product_1", tambahAnginMotor.text);
                await pref.setString("temp_add_outlet_device_product_3", isiBaruMotor.text);
                await pref.setString("temp_add_outlet_device_product_5", tambalBanMotor.text);
                await pref.setString("temp_add_outlet_device_product_7", pasMotor.text);
                await pref.setString("temp_add_outlet_device_product_9", kurangiMotor.text);
                await pref.setString("temp_add_outlet_device_product_11", pauseMotor.text);
                await pref.setString("temp_add_outlet_device_product_13", errorMotor.text);
                push(context, const ManajemenAddOutletMobilPage());
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
              controller: tambahAnginMotor,
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
                if (valuePasMotor) {
                  pasMotor.text = _;
                }
                if (valueKurangiMotor) {
                  kurangiMotor.text = _;
                }
                if (valuePauseMotor) {
                  pauseMotor.text = _;
                }
                if (valueErrorMotor) {
                  errorMotor.text = _;
                }
              },
              decoration: InputDecoration(
                icon: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/motor-2.png')),
                labelText: "HARGA TAMBAH ANGIN MOTOR",
                filled: false,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: isiBaruMotor,
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
                icon: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/motor-2.png')),
                labelText: "HARGA ISI BARU MOTOR",
                filled: false,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: tambalBanMotor,
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
                icon: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/motor-2.png')),
                labelText: "HARGA TAMBAL BAN MOTOR",
                filled: false,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Apabila layanan dibawah ini diaktifkan, maka harga akan sesuai dengan TAMBAH ANGIN MOTOR", style: TextStyle(color: Colors.grey)),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/motor-2.png')),
                  title: const Text("PASS MOTOR", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valuePasMotor,
                  onChanged: (value) {
                    setState(() {
                      valuePasMotor = value;
                      if (value) {
                        pasMotor.text = tambahAnginMotor.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: pasMotor,
                  enabled: !valuePasMotor,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA PASS MOTOR"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/motor-2.png')),
                  title: const Text("KURANGI MOTOR", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valueKurangiMotor,
                  onChanged: (value) {
                    setState(() {
                      valueKurangiMotor = value;
                      if (value) {
                        kurangiMotor.text = tambahAnginMotor.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: kurangiMotor,
                  enabled: !valueKurangiMotor,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA KURANGI MOTOR"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/motor-2.png')),
                  title: const Text("PAUSE MOTOR", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valuePauseMotor,
                  onChanged: (value) {
                    setState(() {
                      valuePauseMotor = value;
                      if (value) {
                        pauseMotor.text = tambahAnginMotor.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: pauseMotor,
                  enabled: !valuePauseMotor,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA PAUSE MOTOR"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SwitchListTile(
                  secondary: SizedBox(height: 40, width: 40, child: Image.asset('assets/icons/motor-2.png')),
                  title: const Text("ERROR MOTOR", style: TextStyle(fontWeight: FontWeight.bold)),
                  value: valueErrorMotor,
                  onChanged: (value) {
                    setState(() {
                      valueErrorMotor = value;
                      if (value) {
                        errorMotor.text = tambahAnginMotor.text;
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: errorMotor,
                  enabled: !valueErrorMotor,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(border: UnderlineInputBorder(), filled: false, labelText: "HARGA ERROR MOTOR"),
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
