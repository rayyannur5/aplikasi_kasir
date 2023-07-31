import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class DetailLaporanPetugasPage extends StatelessWidget {
  final Map data;
  MapController? controllerIn;
  MapController? controllerOut;
  DetailLaporanPetugasPage({super.key, required this.data}) {
    controllerIn = MapController(initPosition: GeoPoint(latitude: double.parse(data['lat_in']), longitude: double.parse(data['lon_in'])));
    controllerOut = MapController(initPosition: GeoPoint(latitude: double.parse(data['lat_out']), longitude: double.parse(data['lon_out'])));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Laporan', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Image.network(data['image_in'])),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("Absen Masuk", style: TextStyles.h2),
                        Text(DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data['created_at']))),
                        Text(data['addr_in']),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: size.width - 40,
              height: 200,
              child: OSMFlutter(
                controller: controllerIn!,
                onMapIsReady: (p0) {
                  controllerIn!.addMarker(GeoPoint(latitude: double.parse(data['lat_in']), longitude: double.parse(data['lon_in'])));
                },
                mapIsLoading: Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      height: 200,
                      width: size.width - 40,
                      color: Colors.black,
                    )),
                initZoom: 18,
              )),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Image.network(data['image_out'])),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("Absen Keluar", style: TextStyles.h2),
                        Text(DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data['updated_at']))),
                        Text(data['addr_out']),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: size.width - 40,
              height: 200,
              child: OSMFlutter(
                controller: controllerOut!,
                onMapIsReady: (p0) {
                  controllerOut!.addMarker(GeoPoint(latitude: double.parse(data['lat_out']), longitude: double.parse(data['lon_out'])));
                },
                mapIsLoading: Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      height: 200,
                      width: size.width - 40,
                      color: Colors.black,
                    )),
                initZoom: 18,
              )),
        ],
      ),
    );
  }
}
