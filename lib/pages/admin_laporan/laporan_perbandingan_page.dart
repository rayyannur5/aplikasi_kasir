import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_two_lines_with_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/textstyles.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/custom_chart_four_lines_with_label.dart';

class LaporanPerbandinganPage extends StatefulWidget {
  LaporanPerbandinganPage({super.key});

  @override
  State<LaporanPerbandinganPage> createState() => _LaporanPerbandinganPageState();
}

class _LaporanPerbandinganPageState extends State<LaporanPerbandinganPage> {
  var date = DateTime.now();
  bool first = true;
  var selectedOutlet = '0';
  var petugasColor = Colors.amberAccent;
  var mesinColor = Colors.greenAccent;

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
            const SizedBox(height: 10),
            SizedBox(
              width: size.width / 2 - 20,
              child: Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.date_range_outlined),
                  title: Text(DateFormat("d MMMM yyyy", "id_ID").format(date), style: TextStyles.p),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    try {
                      DateTime? dateTemp = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2022), lastDate: DateTime.now());
                      if (dateTemp != null) {
                        setState(() {
                          date = dateTemp;
                        });
                      }
                    } catch (e) {}
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: Services.getGrafikMesin(date, selectedOutlet),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 300, width: size.width - 40)));
                } else if (!snapshot.data['success']) {
                  return Column(
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data['errors']),
                    ],
                  );
                }
                print(snapshot.data['data']);

                List dataGrafik = snapshot.data['data'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('Grafik Data Mesin'),
                    ),
                    const SizedBox(height: 10),
                    CustomChart4LinesWithLabel(data: dataGrafik),
                    Row(
                      children: [
                        Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: Theme.of(context).primaryColor),
                        Text('Tambah Angin Motor'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: const Color(0xff159600)),
                        Text('Tambah Angin Mobil'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: Colors.red),
                        Text('Isi Baru Motor'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: Colors.amber),
                        Text('Isi Baru Mobil'),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: mesinColor,
                    padding: const EdgeInsets.all(8),
                    child: Text('AI Device'),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: petugasColor,
                    padding: const EdgeInsets.all(8),
                    child: Text('Admin/Petugas'),
                  ),
                ),
              ],
            ),
            DefaultTabController(
              length: 12,
              initialIndex: getIndex(),
              child: Column(
                children: [
                  const TabBar(isScrollable: true, tabs: [
                    Tab(child: Text('00:00 ~ 01:59')),
                    Tab(child: Text('02:00 ~ 03:59')),
                    Tab(child: Text('04:00 ~ 05:59')),
                    Tab(child: Text('06:00 ~ 07:59')),
                    Tab(child: Text('08:00 ~ 09:59')),
                    Tab(child: Text('10:00 ~ 11:59')),
                    Tab(child: Text('12:00 ~ 13:59')),
                    Tab(child: Text('14:00 ~ 15:59')),
                    Tab(child: Text('16:00 ~ 17:59')),
                    Tab(child: Text('18:00 ~ 19:59')),
                    Tab(child: Text('20:00 ~ 21:59')),
                    Tab(child: Text('22:00 ~ 23:59')),
                  ]),
                  SizedBox(
                    height: 400,
                    child: TabBarView(children: [
                      getPerbandingan(DateTime(date.year, date.month, date.day, 0)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 2)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 4)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 6)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 8)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 10)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 12)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 14)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 16)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 18)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 20)),
                      getPerbandingan(DateTime(date.year, date.month, date.day, 22)),
                    ]),
                  ),
                ],
              ),
            ),
            // FutureBuilder(
            //   future: Services.getPerbandinganReport(date, selectedOutlet),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Column(
            //         children: [
            //           Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 200, width: size.width - 40))),
            //           Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 300, width: size.width - 40))),
            //         ],
            //       );
            //     } else if (!snapshot.data['success']) {
            //       return Column(
            //         children: [
            //           Image.asset('assets/images/error.png'),
            //           Text(snapshot.data['errors']),
            //         ],
            //       );
            //     } else {
            //       // print(snapshot.data)
            //       var data = snapshot.data['data'];
            //       return ListView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: data.length,
            //         itemBuilder: (context, index) => Padding(
            //           padding: EdgeInsets.fromLTRB(data[index]['type_dt'] == '1' ? 0 : 100, 0, data[index]['type_dt'] == '1' ? 100 : 0, 0),
            //           child: Card(
            //             elevation: 0,
            //             color: data[index]['type_dt'] == '1' ? mesinColor : petugasColor,
            //             child: ListTile(
            //               subtitle: Text('${DateFormat("d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at']!))}'),
            //             ),
            //           ),
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget getPerbandingan(date) {
    var controller = ScrollController();
    ValueNotifier<bool> _notifier = ValueNotifier(false);

    int page = 1;
    bool firstLoading = true;
    bool isFinish = false;
    bool isError = false;
    String error = "";
    List items = [];

    fetchData(page) async {
      var res = await Services.getPerbandinganReport(date, selectedOutlet, page);
      if (res['success']) {
        for (int i = 0; i < res['data'].length; i++) {
          items.add(res['data'][i]);
        }
        List dataBaru = res['data'];
        if (dataBaru.isEmpty || dataBaru.length < 10) {
          print('sudah finish');
          isFinish = true;
        }

        firstLoading = false;
        _notifier.value = !_notifier.value;
      } else {
        print(res['errors']);
        isError = true;
        firstLoading = false;
        error = res['errors'];
        _notifier.value = !_notifier.value;
      }
    }

    fetchData(1);

    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
        print('Sampai bawah');
        if (!isFinish) {
          page++;
          fetchData(page);
        }
      }
    });

    return ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, value, child) {
          if (isError) {
            return RefreshIndicator(
                child: ListView(
                  children: [
                    Image.asset('assets/images/error.png'),
                    Text(error),
                  ],
                ),
                onRefresh: () async {
                  items = [];
                  isFinish = false;
                  firstLoading = true;
                  isError = false;
                  _notifier.value = !_notifier.value;
                  await fetchData(1);
                });
          }

          if (firstLoading) {
            return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
          }
          if (items.isEmpty) {
            return RefreshIndicator(
                child: ListView(
                  children: [
                    Image.asset('assets/images/empty.png'),
                  ],
                ),
                onRefresh: () async {
                  items = [];
                  isFinish = false;
                  firstLoading = true;
                  isError = false;
                  _notifier.value = !_notifier.value;
                  await fetchData(1);
                });
          }

          return RefreshIndicator(
            onRefresh: () async {
              items = [];
              isFinish = false;
              firstLoading = true;
              isError = false;
              _notifier.value = !_notifier.value;
              await fetchData(1);
            },
            child: ListView.builder(
              controller: controller,
              itemCount: isFinish ? items.length : items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length && !isFinish) {
                  return SizedBox(height: 40, child: CupertinoActivityIndicator());
                }
                return Padding(
                  padding: EdgeInsets.fromLTRB(items[index]['type_dt'] == '1' ? 0 : 100, 0, items[index]['type_dt'] == '1' ? 100 : 0, 0),
                  child: Card(
                    elevation: 0,
                    color: items[index]['type_dt'] == '1' ? mesinColor : petugasColor,
                    child: ListTile(
                      title: Text(
                          (items[index]['type_dt'] == '1' ? 'AI Device' : (items[index]['type_dt'].toString() == 'null' ? 'Admin' : items[index]['type_dt'].toString())) + "\n${items[index]['name']}"),
                      subtitle: Text('${DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(items[index]['created_at']!))}'),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  int getIndex() {
    var date = DateTime.now();
    int hour = date.hour;
    int index = (hour / 2).toInt();
    return index;
  }
}
