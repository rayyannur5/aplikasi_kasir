import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/services.dart';
import '../../widgets/petugas_drawer.dart';

class PetugasLaporanSetoranPage extends StatelessWidget {
  PetugasLaporanSetoranPage({super.key});
  final day = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  final week = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());
  final month = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: DrawerPetugas(size: size, active: 5),
        appBar: appBar(),
        body: TabBarView(
          children: [
            page(context, day, size, MediaQuery.of(context).viewPadding.top),
            page(context, week, size, MediaQuery.of(context).viewPadding.top),
            page(context, month, size, MediaQuery.of(context).viewPadding.top),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Laporan Absensi'),
      bottom: const TabBar(
        labelColor: Colors.white,
        tabs: [
          Tab(text: 'Hari Ini'),
          Tab(text: '1 Minggu'),
          Tab(text: '1 Bulan'),
        ],
      ),
    );
  }

  Widget page(context, range, size, statusBarHeight) {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          FutureBuilder(
            future: Services().getTabungan(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(height: 100, width: size.width, margin: const EdgeInsets.all(20), color: Colors.black));
              }
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: const EdgeInsets.all(20),
                height: 100,
                width: size.width,
                decoration: BoxDecoration(
                    color: const Color(0xff3943B7),
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(image: AssetImage('assets/images/card-bg.png'), fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jumlah uang yang belum disetorkan', style: TextStyle(color: Colors.white)),
                    Text(numberFormat.format(snapshot.data), style: TextStyles.h1Light),
                  ],
                ),
              );
            },
          ),
          FutureBuilder(
            future: Services().getListSetoran(range),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(height: 50, width: size.width, margin: const EdgeInsets.all(20), color: Colors.black));
              }
              List data = snapshot.data!;
              if (data.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView(
                    children: [Image.asset('assets/images/empty.png')],
                  ),
                );
              }
              return SizedBox(
                height: size.height - appBar().preferredSize.height - statusBarHeight - 120,
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                        child: ListTile(
                            title: Text(DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['date']))),
                            trailing: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: const Color(0xff449DD1), borderRadius: BorderRadius.circular(10)),
                              child: Text(numberFormat.format(int.parse(data[index]['total'])), style: const TextStyle(color: Colors.white)),
                            ))),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    // return StatefulBuilder(
    //   builder: (context, setState) => FutureBuilder(
    //     future: Services().getLaporanPetugas(range),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Column(
    //           children: [
    //             Shimmer.fromColors(
    //                 baseColor: Colors.transparent,
    //                 highlightColor: Colors.white.withOpacity(0.5),
    //                 child: Container(
    //                   height: 130,
    //                   width: size.width,
    //                   margin: const EdgeInsets.all(20),
    //                   color: Colors.black,
    //                 )),
    //             Shimmer.fromColors(
    //                 baseColor: Colors.transparent,
    //                 highlightColor: Colors.white.withOpacity(0.5),
    //                 child: Container(
    //                   height: 50,
    //                   width: size.width,
    //                   margin: const EdgeInsets.all(20),
    //                   color: Colors.black,
    //                 )),
    //           ],
    //         );
    //       }
    //       List data = snapshot.data!;
    //       if (data.isEmpty) {
    //         return RefreshIndicator(
    //           onRefresh: () async {
    //             setState(() {});
    //           },
    //           child: ListView(
    //             children: [Image.asset('assets/images/empty.png')],
    //           ),
    //         );
    //       }
    //       int countTepatWaktu = 0;
    //       for (var element in data) {
    //         if (element['keterangan'] == 'Tepat Waktu') {
    //           countTepatWaktu++;
    //         }
    //       }
    //       return Column(
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    //             padding: const EdgeInsets.all(20),
    //             width: size.width,
    //             decoration: BoxDecoration(
    //                 color: const Color(0xff3943B7),
    //                 borderRadius: BorderRadius.circular(10),
    //                 image: const DecorationImage(image: AssetImage('assets/images/card-bg.png'), fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter)),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const Text('Tepat Waktu', style: TextStyle(color: Colors.white)),
    //                 Text('$countTepatWaktu Kali', style: TextStyles.h1Light),
    //                 const Text('Terlambat', style: TextStyle(color: Colors.white)),
    //                 Text('${data.length - countTepatWaktu} Kali', style: TextStyles.h1Light),
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: size.height - appBar().preferredSize.height - statusBarHeight - 240,
    //             child: RefreshIndicator(
    //               onRefresh: () async {
    //                 setState(() {});
    //               },
    //               child: ListView.builder(
    //                 padding: const EdgeInsets.all(20),
    //                 itemCount: data.length,
    //                 itemBuilder: (context, index) => Card(
    //                     child: ListTile(
    //                   onTap: () async {
    //                     await Future.delayed(const Duration(milliseconds: 200));
    //                     push(context, DetailLaporanPetugasPage(data: data[index]));
    //                   },
    //                   contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //                   title: Text(
    //                       'Masuk : ${DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at']))}\nKeluar :${data[index]['created_at'] == data[index]['updated_at'] ? 'Belum Absen Keluar' : (DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['updated_at'])))}',
    //                       style: const TextStyle(fontSize: 14)),
    //                   trailing: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: [
    //                       Container(
    //                         padding: const EdgeInsets.all(5),
    //                         decoration: BoxDecoration(color: const Color(0xff3943B7), borderRadius: BorderRadius.circular(10)),
    //                         child: Text('Shift ${data[index]['shift']}', style: const TextStyle(color: Colors.white)),
    //                       ),
    //                       const SizedBox(height: 4),
    //                       Container(
    //                         padding: const EdgeInsets.all(5),
    //                         decoration: BoxDecoration(color: const Color(0xff159600), borderRadius: BorderRadius.circular(10)),
    //                         child: Text(data[index]['keterangan'], style: const TextStyle(color: Colors.white)),
    //                       ),
    //                     ],
    //                   ),
    //                 )),
    //               ),
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    // );
  }
}
