import 'dart:io';

import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/api/user_information.dart';
import 'package:aplikasi_kasir/pages/petugas_laporan/petugas_laporan_tambahan_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

class PetugasLaporanTambahanCreatePage extends StatelessWidget {
  final Position position;
  final String imagePath;
  MapController? controllerIn;
  Map? selectedCategory;

  PetugasLaporanTambahanCreatePage({super.key, required this.imagePath, required this.position}) {
    controllerIn = MapController(initPosition: GeoPoint(latitude: position.latitude, longitude: position.longitude));
  }

  var desc = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isKirim = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Tambahan')),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            fotoMap(size, context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: desc,
                validator: (value) => value!.isEmpty ? 'Kolom ini harus diisi' : null,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
            ),
            const SizedBox(height: 20),
            pilihKategori(),
            Spacer(),
            StatefulBuilder(builder: (context, setstate) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: isKirim
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            setstate(() => isKirim = true);
                            var userInformation = await UserInformation.get();
                            if (!userInformation['success']) {
                              setstate(() => isKirim = false);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(userInformation['errors'])));
                              return;
                            }
                            var storeData = await Services.getOneStore(userInformation['data'][0]['store_active_id']);
                            if (!storeData['success']) {
                              setstate(() => isKirim = false);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(storeData['errors'])));
                              return;
                            }
                            var jarak = Geolocator.distanceBetween(double.parse(storeData['data'][0]['lat']), double.parse(storeData['data'][0]['lon']), position.latitude, position.longitude);
                            var resp = await Services.createLaporanTambahan(imagePath, position.latitude, position.longitude, jarak, selectedCategory!['id'], desc.text);
                            if (resp['success']) {
                              return pushAndRemoveUntil(context, PetugasLaporanTambahanPage());
                            } else {
                              setstate(() => isKirim = false);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['errors'])));
                            }
                          },
                    child: isKirim ? CupertinoActivityIndicator(color: Colors.white) : Text('Kirim')),
              );
            }),
          ],
        ),
      ),
    );
  }

  Padding pilihKategori() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
        future: Services.getLaporanKategori(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: const TextField());
          if (!snapshot.data['success']) {
            return Column(
              children: [
                Image.asset('assets/images/error.png'),
                Text(snapshot.data['errors']),
              ],
            );
          }
          return DropdownButtonFormField(
            value: selectedCategory,
            hint: Text("Pilih Kategori"),
            validator: (value) => value == null ? 'Kolom ini harus diisi' : null,
            items: [
              for (int i = 0; i < snapshot.data['data'].length; i++)
                DropdownMenuItem(
                  value: snapshot.data['data'][i],
                  child: Text(snapshot.data['data'][i]['name']),
                ),
            ],
            onChanged: (value) {
              selectedCategory = value as Map;
            },
          );
        },
      ),
    );
  }

  Stack fotoMap(Size size, BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size.width,
          height: 100,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 100,
                      height: 150,
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                      width: size.width - 200,
                      height: 150,
                      child: OSMFlutter(
                        osmOption: OSMOption(zoomOption: ZoomOption(initZoom: 18)),
                        controller: controllerIn!,
                        onMapIsReady: (p0) {
                          controllerIn!.addMarker(GeoPoint(latitude: position.latitude, longitude: position.longitude));
                        },

                        // mapIsLoading: Shimmer.fromColors(
                        //     baseColor: Colors.transparent,
                        //     highlightColor: Colors.white.withOpacity(0.5),
                        //     child: Container(
                        //       color: Colors.black,
                        //       width: size.width - 200,
                        //       height: 150,
                        //     )),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
