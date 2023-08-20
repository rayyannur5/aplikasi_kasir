import 'dart:io';

import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class CreateAbsensiPage extends StatelessWidget {
  final Position position;
  final String imagePath;

  MapController? controllerIn;
  int? selectedShift;
  Map? selectedOutlet;

  CreateAbsensiPage({super.key, required this.imagePath, required this.position}) {
    controllerIn = MapController(initPosition: GeoPoint(latitude: position.latitude, longitude: position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Kirim Absensi')),
      body: Column(
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
            child: ElevatedButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (selectedShift == null) {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(content: const Text('Pilih Shift Terlebih Dahulu'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                    return;
                  } else if (selectedOutlet == null) {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(content: const Text('Pilih Outlet Terlebih Dahulu'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                    return;
                  } else if (Geolocator.distanceBetween(double.parse(selectedOutlet!['lat']), double.parse(selectedOutlet!['lon']), position.latitude, position.longitude) > 30) {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(content: const Text('Anda Diluar Jangkauan'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                    return;
                  }
                },
                child: const Text('Kirim')),
          ),
        ],
      ),
    );
  }

  Padding pilihShift() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
        future: Services().getShift(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: const TextField());
          return StatefulBuilder(builder: (context, setstate) {
            return Row(
              children: [
                for (int i = 0; i < snapshot.data!.length; i++)
                  Expanded(
                      child: GestureDetector(
                    onTap: () => setstate(() {
                      selectedShift = i;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: selectedShift == i ? Theme.of(context).primaryColor : Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Text(snapshot.data![i]['nama'], style: TextStyle(color: selectedShift == i ? Colors.white : Colors.black)),
                    ),
                  )),
              ],
            );
          });
        },
      ),
    );
  }

  Padding pilihOutlet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder(
          future: Services().getOutlets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: const TextField());
            selectedOutlet = snapshot.data!.first;
            return DropdownButtonFormField(
              value: snapshot.data['data'].first,
              items: snapshot.data['data']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e['nama']),
                      ))
                  .toList(),
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
                        initZoom: 18,
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
