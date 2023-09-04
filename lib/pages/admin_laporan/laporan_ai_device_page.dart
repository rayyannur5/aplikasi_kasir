import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class LaporanAIDevicePage extends StatefulWidget {
  LaporanAIDevicePage({super.key});

  @override
  State<LaporanAIDevicePage> createState() => _LaporanAIDevicePageState();
}

class _LaporanAIDevicePageState extends State<LaporanAIDevicePage> {
  var date = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  bool first = true;

  var selectedOutlet = '0';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan AI Device')),
      drawer: DrawerAdmin(active: 8, size: size),
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
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data['errors']),
                    ],
                  );
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
                    },
                  );
                }
              },
            ),
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
            const SizedBox(height: 10),
            // ref.watch(futureReportAIDeviceProvider(parameterAI)).when(
            //       skipLoadingOnRefresh: false,
            //       data: (data) {
            //         List<Map> dataGrafik = [];
            //         var dataMap = data['data'] as Map;
            //         dataMap.forEach(
            //           (key, value) {
            //             dataGrafik.add({
            //               'label': key,
            //               'value': value,
            //             });
            //           },
            //         );
            //         return Column(
            //           children: [
            //             Card(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(20.0),
            //                 child: CustomChartWithLabel(data: dataGrafik),
            //               ),
            //             ),
            //             Card(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(20.0),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(data['device_nama']),
            //                     const SizedBox(height: 10),
            //                     Column(
            //                       children: data['data']
            //                           .entries
            //                           .map<Widget>((e) => Row(
            //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                                 children: [Text(e.key.toString(), style: TextStyles.pBold), Text("${e.value.toString()} Ban")],
            //                               ))
            //                           .toList(),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         );
            //       },
            //       error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
            //       loading: () => Column(
            //         children: [
            //           Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 200, width: size.width - 40))),
            //           Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 300, width: size.width - 40))),
            //         ],
            //       ),
            //     )
          ],
        ),
      ),
    );
  }
}
