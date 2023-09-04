import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/textstyles.dart';

class LaporanTambahanPetugasPage extends StatefulWidget {
  const LaporanTambahanPetugasPage({super.key});

  @override
  State<LaporanTambahanPetugasPage> createState() => _LaporanTambahanPetugasPageState();
}

class _LaporanTambahanPetugasPageState extends State<LaporanTambahanPetugasPage> {
  DateTimeRange range = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Tambahan Petugas')),
      drawer: DrawerAdmin(size: size, active: 14),
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
              future: Services.getAdminLaporanTambahan(range),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: const Card(child: ListTile())),
                  );
                } else if (!snapshot.data['success']) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data['errors']),
                    ],
                  );
                } else {
                  List data = snapshot.data['data'];

                  if (data.isEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Image.asset('assets/images/empty.png'),
                      ],
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
