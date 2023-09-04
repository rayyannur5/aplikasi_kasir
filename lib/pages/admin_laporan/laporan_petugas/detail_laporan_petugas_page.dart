import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../api/services.dart';
import '../../../utils/formatter.dart';
import '../../../utils/navigator.dart';
import '../../print_page/detail_transaksi_page.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.print)),
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
                osmOption: OSMOption(zoomOption: ZoomOption(initZoom: 18)),
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
              )),
          const Divider(),
          data['created_at'] == data['updated_at']
              ? SizedBox()
              : Row(
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
          data['created_at'] == data['updated_at']
              ? Text("Belum Absen Keluar")
              : SizedBox(
                  width: size.width - 40,
                  height: 200,
                  child: OSMFlutter(
                    osmOption: OSMOption(zoomOption: ZoomOption(initZoom: 18)),
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
                  )),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          FutureBuilder(
              future: Services.detailAbsensi(data['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                      baseColor: Colors.transparent,
                      highlightColor: Colors.white.withOpacity(0.5),
                      child: Container(
                        height: 200,
                        width: size.width - 40,
                        color: Colors.black,
                      ));
                }
                if (!snapshot.data['success']) {
                  return Column(
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data['errors']),
                    ],
                  );
                }
                return DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: 'Rekap'),
                            Tab(text: 'Transaksi'),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 20),
                                  for (int i = 0; i < snapshot.data['data']['recap']['items'].length; i++)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${snapshot.data['data']['recap']['items'][i]['qty']}x ${snapshot.data['data']['recap']['items'][i]['name']}"),
                                        Text(numberFormat.format(int.parse(snapshot.data['data']['recap']['items'][i]['price'])), style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total"),
                                      Text(numberFormat.format(snapshot.data['data']['recap']['total']), style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tabungan"),
                                      Text(numberFormat.format(int.parse(snapshot.data['data']['recap']['tabungan'])), style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              ListView.builder(
                                itemCount: snapshot.data['data']['transactions'].length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data['data']['transactions'];
                                  return Card(
                                    child: ListTile(
                                      title: Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at'])), style: TextStyles.h2),
                                      subtitle: Text(data[index]['store']),
                                      trailing: Container(
                                        height: double.infinity,
                                        width: 100,
                                        padding: const EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                                        child: Text(numberFormat.format(int.parse(data[index]['paid'])), style: TextStyles.h2Light),
                                      ),
                                      onTap: () => Future.delayed(const Duration(milliseconds: 200), () => push(context, DetailTransaksi(id: data[index]['id']))),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
              })
        ],
      ),
    );
  }
}
