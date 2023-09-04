import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_petugas/detail_laporan_petugas_page.dart';
import 'package:aplikasi_kasir/pages/petugas_absensi/camera_absensi_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/petugas_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PetugasAbsensiPage extends StatelessWidget {
  const PetugasAbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: DrawerPetugas(size: size, active: 2),
          appBar: appBar(context),
          body: TabBarView(
            children: [
              pageBody(DateTimeRange(start: DateTime.now(), end: DateTime.now())),
              pageBody(DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now())),
              pageBody(DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now())),
            ],
          ),
        ));
  }

  StatefulBuilder pageBody(DateTimeRange range) {
    return StatefulBuilder(
      builder: (context, setstate) {
        return FutureBuilder(
          future: Services.getLaporanPetugas(range),
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
            List data = snapshot.data!['data'];
            if (data.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  setstate(() {
                    data = [];
                  });
                },
                child: ListView(
                  children: [
                    Image.asset('assets/images/empty.png'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                setstate(() {
                  data = [];
                });
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
                        'Masuk : ${DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at']))}\nKeluar :${data[index]['created_at'] == data[index]['updated_at'] ? 'Belum Absen Keluar' : (DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['updated_at'])))}',
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text('Absensi'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Column(
          children: [
            Container(
              height: 200 - AppBar().preferredSize.height,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff449DD1),
              ),
              child: FutureBuilder(
                future: Services.getLaporanPetugas(DateTimeRange(start: DateTime.now(), end: DateTime.now())),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CupertinoActivityIndicator(color: Colors.white));
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
                    return Row(
                      children: [
                        const Expanded(child: Icon(Icons.account_circle, color: Colors.white, size: 80)),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Belum Absen', style: TextStyle(fontSize: 16, color: Colors.white)),
                              ElevatedButton(
                                  onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => materialPush(context, const CameraAbsensiPage())),
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff78C0E0))),
                                  child: const Text('Absen Masuk')),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  if (data.last['created_at'] == data.last['updated_at']) {
                    return Row(
                      children: [
                        Expanded(
                          child: Image.network(
                            data.last['image_in'],
                            loadingBuilder: (context, child, chunk) {
                              print(chunk);
                              if (chunk == null) {
                                return child;
                              }
                              return const CupertinoActivityIndicator(color: Colors.white);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data.last['created_at'])), style: const TextStyle(fontSize: 16, color: Colors.white)),
                              ElevatedButton(
                                  onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => materialPush(context, const CameraAbsensiPage())),
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff78C0E0))),
                                  child: const Text('Absen Keluar')),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          data.last['image_out'],
                          loadingBuilder: (context, child, chunk) {
                            if (chunk == null) {
                              return child;
                            }
                            return const CupertinoActivityIndicator(color: Colors.white);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data.last['updated_at'])), style: const TextStyle(fontSize: 16, color: Colors.white)),
                            ElevatedButton(
                                onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => push(context, DetailLaporanPetugasPage(data: data.last))),
                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff78C0E0))),
                                child: const Text('Laporan')),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Hari Ini'),
                Tab(text: '1 Minggu'),
                Tab(text: '1 Bulan'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
