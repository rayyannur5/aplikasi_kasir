import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_add_outlet_motor_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/pick_location_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOutletPage extends StatefulWidget {
  const AddOutletPage({super.key, required this.dataDevice});
  final Map dataDevice;

  @override
  State<AddOutletPage> createState() => _AddOutletPageState();
}

class _AddOutletPageState extends State<AddOutletPage> {
  final TextEditingController nama = TextEditingController();
  final TextEditingController kota = TextEditingController();
  final TextEditingController lokasi = TextEditingController();
  // String lokasi = "Lokasi";
  double lat = 0;
  double lon = 0;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Outlet/Cabang', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: Text('ID Device       : ${widget.dataDevice['id']}'),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: Text('Nama Device : ${widget.dataDevice['name']}', style: const TextStyle(overflow: TextOverflow.ellipsis)),
              ),
              TextFormField(
                  controller: nama,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Kolom tidak boleh kosong";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Nama Outlet')),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: Local.getLogin(),
                  builder: (context, snapshot) {
                    if (!snapshot.data!['value']) {
                      return TextFormField(
                          controller: kota,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom tidak boleh kosong";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Kota'));
                    } else {
                      return FutureBuilder(
                          future: Services.getCities(),
                          builder: (context, res) {
                            List data = res.data['data'];
                            return DropdownButtonFormField(
                              value: data.first,
                              items: data
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e['name']),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (value) {},
                            );
                          });
                    }
                  }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                          controller: lokasi,
                          enabled: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom tidak boleh kosong";
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Lokasi')
                          // height: 60,
                          // width: double.infinity,
                          // padding: const EdgeInsets.all(10),
                          // alignment: Alignment.centerLeft,
                          // decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                          // child: Text(lokasi),
                          )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            GeoPoint resultGeoPoint = await Navigator.push(context, MaterialPageRoute(builder: (context) => const PickLoactionPage()));
                            if (mounted) {
                              setState(() {
                                lat = resultGeoPoint.latitude;
                                lon = resultGeoPoint.longitude;
                                lokasi.text = "${resultGeoPoint.latitude}, ${resultGeoPoint.longitude}";
                              });
                            }
                          },
                          child: const Text('Pilih Lokasi', textAlign: TextAlign.center))),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      await Future.delayed(const Duration(milliseconds: 200));

                      var pref = await SharedPreferences.getInstance();
                      await pref.setString("temp_add_outlet_device_id", widget.dataDevice['id']);
                      await pref.setString("temp_add_outlet_name", nama.text);
                      await pref.setDouble("temp_add_outlet_lat", lat);
                      await pref.setDouble("temp_add_outlet_lon", lon);
                      await pref.setString("temp_city", kota.text);
                      push(context, const ManajemenAddOutletMotorPage());
                    }
                  },
                  child: const Text('Tambah')),
            ],
          ),
        ),
      ),
    );
  }
}
