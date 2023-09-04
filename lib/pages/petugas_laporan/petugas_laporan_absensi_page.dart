import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/services.dart';
import '../../utils/navigator.dart';
import '../../widgets/petugas_drawer.dart';
import '../admin_laporan/laporan_petugas/detail_laporan_petugas_page.dart';

class PetugasLaporanAbsensiPage extends StatelessWidget {
  PetugasLaporanAbsensiPage({super.key});
  final day = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  final week = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());
  final month = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: DrawerPetugas(size: size, active: 4),
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
        unselectedLabelColor: Colors.grey,
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
      builder: (context, setState) => FutureBuilder(
        future: Services().getLaporanPetugas(range),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      height: 130,
                      width: size.width,
                      margin: const EdgeInsets.all(20),
                      color: Colors.black,
                    )),
                Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      height: 50,
                      width: size.width,
                      margin: const EdgeInsets.all(20),
                      color: Colors.black,
                    )),
              ],
            );
          }
          if (!snapshot.data['success']) {
            return Column(
              children: [
                Image.asset('assets/images/error.png'),
                Text(snapshot.data['errors']),
              ],
            );
          }
          List data = snapshot.data['data'];
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
          int countTepatWaktu = 0;
          for (var element in data) {
            if (element['status'] == '1') {
              countTepatWaktu++;
            }
          }
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: const EdgeInsets.all(20),
                width: size.width,
                decoration: BoxDecoration(
                    color: const Color(0xff3943B7),
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(image: AssetImage('assets/images/card-bg.png'), fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tepat Waktu', style: TextStyle(color: Colors.white)),
                    Text('$countTepatWaktu Kali', style: TextStyles.h1Light),
                    const Text('Terlambat', style: TextStyle(color: Colors.white)),
                    Text('${data.length - countTepatWaktu} Kali', style: TextStyles.h1Light),
                  ],
                ),
              ),
              SizedBox(
                height: size.height - appBar().preferredSize.height - statusBarHeight - 240,
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                        child: ListTile(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        push(context, DetailLaporanPetugasPage(data: data[index]));
                      },
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      title: Text(
                          'Masuk : ${DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at']))}\nKeluar :${data[index]['created_at'] == data[index]['updated_at'] ? 'Belum Absen Keluar' : (DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['updated_at'])))}',
                          style: const TextStyle(fontSize: 12)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: const Color(0xff3943B7), borderRadius: BorderRadius.circular(10)),
                            child: Text('Shift ${data[index]['shift']}', style: const TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: data[index]['status'] == '1' ? const Color(0xff159600) : Colors.red, borderRadius: BorderRadius.circular(10)),
                            child: Text(data[index]['status'] == '1' ? 'Tepat Waktu' : 'Terlambat', style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
