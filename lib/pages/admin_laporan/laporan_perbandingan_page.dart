import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_two_lines_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/textstyles.dart';
import '../../widgets/admin_drawer.dart';

class LaporanPerbandinganPage extends StatefulWidget {
  LaporanPerbandinganPage({super.key});

  @override
  State<LaporanPerbandinganPage> createState() => _LaporanPerbandinganPageState();
}

class _LaporanPerbandinganPageState extends State<LaporanPerbandinganPage> {
  var date = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  bool first = true;
  var selectedOutlet = '0';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Perbandingan')),
      drawer: DrawerAdmin(active: 10, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            FutureBuilder(
              future: Services().getOutlets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Container(height: 55, color: Colors.black));
                } else if (!snapshot.data['success']) {
                  return const Center(child: Text('Gagal Ambil Data'));
                } else {
                  List data = snapshot.data['data'];
                  if (first) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        selectedOutlet = data.first['id'];
                      });
                    });
                    first = false;
                  }
                  return DropdownButtonFormField(
                      items: data.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']))).toList(),
                      value: selectedOutlet,
                      onChanged: (value) {
                        setState(() {
                          selectedOutlet = value.toString();
                        });
                      });
                }
              },
            ),
            // ref.watch(futureGetOutletsProvider).when(
            //       data: (result) {
            //
            //       },
            //       error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
            //       loading: () => ,
            //     ),
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                    width: size.width / 2 - 20,
                    child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: const Icon(Icons.date_range_outlined),
                          title: Text(DateFormat("d MMMM yyyy", "id_ID").format(date.start), style: TextStyles.p),
                          onTap: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            try {
                              DateTimeRange? dateTemp = await showDateRangePicker(context: context, firstDate: DateTime(2022), lastDate: DateTime(2030));
                              if (dateTemp != null) {
                                setState(() {
                                  date = dateTemp;
                                });
                              }
                            } catch (e) {}
                          },
                        ))),
                SizedBox(
                    width: size.width / 2 - 20,
                    child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: const Icon(Icons.date_range_outlined),
                          title: Text(DateFormat("d MMMM yyyy", "id_ID").format(date.end), style: TextStyles.p),
                          onTap: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            try {
                              DateTimeRange? dateTemp = await showDateRangePicker(context: context, firstDate: DateTime(2022), lastDate: DateTime(2030));
                              if (dateTemp != null) {
                                setState(() {
                                  date = dateTemp;
                                });
                              }
                            } catch (e) {}
                          },
                        ))),
              ],
            ),
            FutureBuilder(
              future: Services.getPerbandinganReport(date, selectedOutlet),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 200, width: size.width - 40))),
                      Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 300, width: size.width - 40))),
                    ],
                  );
                } else if (!snapshot.data['success']) {
                  return Column(
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data['errors']),
                    ],
                  );
                } else {
                  // print(snapshot.data)
                  var data = snapshot.data['data'];
                  List<Map> dataGrafik = [];
                  for (var element in data) {
                    dataGrafik.add({'label': DateFormat("d MMMM yyyy", "id_ID").format(DateTime.parse(element['date']!)), 'value1': element['total_device']!, 'value2': element['total_kasir']!});
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      CustomChart2LinesWithLabel(data: dataGrafik),
                      for (int i = 0; i < data.length; i++)
                        Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            title: Text(data[i]['pegawai']!),
                            subtitle: Text('${DateFormat("d MMMM yyyy", "id_ID").format(DateTime.parse(data[i]['date']!))}\nSelisih : ${numberFormat.format(data[i]['selisih']!)}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: const Color(0xff3943B7), borderRadius: BorderRadius.circular(10)),
                                  child: Text('AI Device : ${numberFormat.format(data[i]['total_device']!)}', style: const TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: const Color(0xff159600), borderRadius: BorderRadius.circular(10)),
                                  child: Text('Kasir : ${numberFormat.format(data[i]['total_kasir']!)}', style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
