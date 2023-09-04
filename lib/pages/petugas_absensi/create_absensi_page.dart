import 'dart:io';

import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/api/user_information.dart';
import 'package:aplikasi_kasir/pages/petugas_absensi/petugas_absensi_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class CreateAbsensiPage extends StatelessWidget {
  final Position position;
  final String imagePath;

  MapController? controllerIn;
  int? selectedShift;
  Map? selectedOutlet;
  bool kirim = false;

  CreateAbsensiPage({super.key, required this.imagePath, required this.position}) {
    controllerIn = MapController(initPosition: GeoPoint(latitude: position.latitude, longitude: position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Kirim Absensi')),
      body: FutureBuilder(
          future: Services.getUserInformation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
            if (!snapshot.data['success']) {
              return Column(
                children: [
                  Image.asset('assets/images/error.png'),
                  Text(snapshot.data['errors']),
                ],
              );
            }
            if (snapshot.data['data'][0]['status_attendance'] == '1') {
              return Column(
                children: [
                  fotoMap(size, context),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: StatefulBuilder(builder: (context, setstate) {
                      return ElevatedButton(
                          onPressed: kirim
                              ? null
                              : () async {
                                  setstate(() => kirim = true);
                                  await Future.delayed(const Duration(milliseconds: 200));
                                  var storeData = await Services.getOneStore(snapshot.data['data'][0]['store_active_id']);

                                  if (!storeData['success']) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(storeData['errors'])));
                                    return;
                                  }
                                  print(snapshot.data['data'][0]['store_active_id']);
                                  var jarak = Geolocator.distanceBetween(double.parse(storeData['data'][0]['lat']), double.parse(storeData['data'][0]['lon']), position.latitude, position.longitude);
                                  // else if (jarak > 30) {
                                  //   showCupertinoDialog(
                                  //       context: context,
                                  //       builder: (context) => CupertinoAlertDialog(content: const Text('Anda Diluar Jangkauan'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                                  //   return;
                                  // }
                                  await UserInformation.delete();

                                  var res = await Services.updateAttendances(File(imagePath), position.latitude, position.longitude, jarak);
                                  if (res['success']) {
                                    await UserInformation.delete();
                                    pushAndRemoveUntil(context, PetugasAbsensiPage());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                                    setstate(() => kirim = false);
                                  }
                                },
                          child: kirim ? const CupertinoActivityIndicator(color: Colors.white) : const Text('Kirim'));
                    }),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  fotoMap(size, context),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text('Pilih Outlet'),
                  ),
                  pilihOutlet(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                    child: Text('Pilih Shift'),
                  ),
                  pilihShift(),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: StatefulBuilder(builder: (context, setstate) {
                      return ElevatedButton(
                          onPressed: kirim
                              ? null
                              : () async {
                                  setstate(() => kirim = true);
                                  await Future.delayed(const Duration(milliseconds: 200));
                                  if (selectedOutlet == null) {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(content: const Text('Pilih Outlet Terlebih Dahulu'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                                    return;
                                  } else if (selectedShift == null) {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) =>
                                            CupertinoAlertDialog(content: const Text('Pilih Shift Terlebih Dahulu'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                                    return;
                                  }
                                  var jarak = Geolocator.distanceBetween(double.parse(selectedOutlet!['lat']), double.parse(selectedOutlet!['lon']), position.latitude, position.longitude);
                                  // else if (jarak > 30) {
                                  //   showCupertinoDialog(
                                  //       context: context,
                                  //       builder: (context) => CupertinoAlertDialog(content: const Text('Anda Diluar Jangkauan'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                                  //   return;
                                  // }

                                  var res = await Services.createAttendances(File(imagePath), selectedOutlet!['id'], selectedShift!, position.latitude, position.longitude, jarak);
                                  if (res['success']) {
                                    await UserInformation.delete();
                                    pushAndRemoveUntil(context, PetugasAbsensiPage());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                                    setstate(() => kirim = false);
                                  }
                                },
                          child: kirim ? const CupertinoActivityIndicator(color: Colors.white) : const Text('Kirim'));
                    }),
                  ),
                ],
              );
            }
          }),
    );
  }

  Padding pilihShift() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StatefulBuilder(builder: (context, setstate) {
        return Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () => setstate(() {
                selectedShift = 1;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: selectedShift == 1 ? Theme.of(context).primaryColor : Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: Text('Shift 1', style: TextStyle(color: selectedShift == 1 ? Colors.white : Colors.black)),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () => setstate(() {
                selectedShift = 2;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: selectedShift == 2 ? Theme.of(context).primaryColor : Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: Text('Shift 2', style: TextStyle(color: selectedShift == 2 ? Colors.white : Colors.black)),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () => setstate(() {
                selectedShift = 3;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: selectedShift == 3 ? Theme.of(context).primaryColor : Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                child: Text('Shift 3', style: TextStyle(color: selectedShift == 3 ? Colors.white : Colors.black)),
              ),
            )),
          ],
        );
      }),
    );
  }

  Padding pilihOutlet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
          future: Services().getOutlets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: const TextField());
            if (!snapshot.data['success']) {
              return Column(
                children: [
                  Image.asset('assets/images/error.png'),
                  Text(snapshot.data['errors']),
                ],
              );
            }
            return DropdownButtonFormField(
              value: selectedOutlet,
              hint: Text("Pilih Outlet"),
              items: [
                for (int i = 0; i < snapshot.data['data'].length; i++)
                  DropdownMenuItem(
                    value: snapshot.data['data'][i],
                    child: Text(snapshot.data['data'][i]['name']),
                  ),
              ],
              onChanged: (value) {
                selectedOutlet = value as Map;
              },
            );
          }),
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
                        mapIsLoading: Shimmer.fromColors(
                            baseColor: Colors.transparent,
                            highlightColor: Colors.white.withOpacity(0.5),
                            child: Container(
                              color: Colors.black,
                              width: size.width - 200,
                              height: 150,
                            )),
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
