import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_petugas/detail_laporan_petugas_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/textstyles.dart';
import '../../../widgets/admin_drawer.dart';

class LaporanPetugasPage extends StatefulWidget {
  const LaporanPetugasPage({super.key});

  @override
  State<LaporanPetugasPage> createState() => _LaporanPetugasPageState();
}

class _LaporanPetugasPageState extends State<LaporanPetugasPage> {
  DateTimeRange range = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Absensi Petugas')),
      drawer: DrawerAdmin(active: 11, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                SizedBox(
                    width: size.width / 2 - 20,
                    child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: const Icon(Icons.date_range_outlined),
                          title: Text(DateFormat("d MMMM yyyy", "id_ID").format(range.start), style: TextStyles.p),
                          onTap: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            try {
                              DateTimeRange? dateTemp = await showDateRangePicker(context: context, firstDate: DateTime(2022), lastDate: DateTime(2030));
                              setState(() {
                                range = dateTemp!;
                              });
                            } catch (e) {}
                          },
                        ))),
                SizedBox(
                  width: size.width / 2 - 20,
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(Icons.date_range_outlined),
                      title: Text(DateFormat("d MMMM yyyy", "id_ID").format(range.end), style: TextStyles.p),
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        try {
                          DateTimeRange? dateTemp = await showDateRangePicker(context: context, firstDate: DateTime(2022), lastDate: DateTime(2030));
                          setState(() {
                            range = dateTemp!;
                          });
                        } catch (e) {}
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: Services.getLaporanPetugas(range),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: const Card(child: ListTile())),
                  );
                } else if (!snapshot.data['success']) {
                  return ListView(
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data['errors']),
                    ],
                  );
                }
                List data = snapshot.data['data'];
                if (data.isEmpty) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset('assets/images/empty.png'),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      title: Text("${data[index]['store']} | ${data[index]['pegawai']}"),
                      subtitle: Text(
                          "Absen Masuk : ${DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at']))}\nAbsen Keluar : ${data[index]['created_at'] == data[index]['updated_at'] ? 'Belum Absen Keluar' : DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['updated_at']))}",
                          style: const TextStyle(fontSize: 10)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: const Color(0xff3943B7), borderRadius: BorderRadius.circular(10)),
                            child: Text(data[index]['status'] == '1' ? 'Tepat Waktu' : 'Terlambat', style: const TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: const Color(0xff159600), borderRadius: BorderRadius.circular(10)),
                            child: Text(numberFormat.format(int.parse(data[index]['omset'])), style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        push(context, DetailLaporanPetugasPage(data: data[index]));
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
