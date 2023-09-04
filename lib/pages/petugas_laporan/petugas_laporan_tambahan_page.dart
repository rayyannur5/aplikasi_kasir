import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/petugas_laporan/petugas_laporan_tambahan_camera_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/petugas_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PetugasLaporanTambahanPage extends StatefulWidget {
  const PetugasLaporanTambahanPage({super.key});

  @override
  State<PetugasLaporanTambahanPage> createState() => _PetugasLaporanTambahanPageState();
}

class _PetugasLaporanTambahanPageState extends State<PetugasLaporanTambahanPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Tambahan')),
      drawer: DrawerPetugas(active: 8, size: size),
      floatingActionButton: FloatingActionButton(onPressed: () => push(context, PetugasLaporanTambahanCameraPage()), child: Icon(Icons.add_a_photo)),
      body: FutureBuilder(
        future: Services.getPetugasLaporanTambahan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                const SizedBox(height: 15),
                Shimmer.fromColors(
                    child: Container(height: 60, margin: EdgeInsets.fromLTRB(20, 5, 20, 5), color: Colors.black), baseColor: Colors.white, highlightColor: Colors.black.withOpacity(0.5)),
                Shimmer.fromColors(
                    child: Container(height: 60, margin: EdgeInsets.fromLTRB(20, 5, 20, 5), color: Colors.black), baseColor: Colors.white, highlightColor: Colors.black.withOpacity(0.5)),
                Shimmer.fromColors(
                    child: Container(height: 60, margin: EdgeInsets.fromLTRB(20, 5, 20, 5), color: Colors.black), baseColor: Colors.white, highlightColor: Colors.black.withOpacity(0.5)),
              ],
            );
          }
          if (!snapshot.data['success']) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [Image.asset('assets/images/error.png'), Text(snapshot.data['errors'])],
              ),
            );
          }
          List data = snapshot.data['data'];
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: data.length,
              itemBuilder: (context, index) => Card(
                  child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data[index]['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at'])), style: TextStyle(fontSize: 10)),
                          Text(data[index]['addr'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9)),
                          const SizedBox(height: 10),
                          Text(data[index]['description']),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(data[index]['image']),
                      ),
                    ),
                  )
                ],
              )),
            ),
          );
        },
      ),
    );
  }
}
