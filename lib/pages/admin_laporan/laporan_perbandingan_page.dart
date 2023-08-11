import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_two_lines_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/textstyles.dart';
import '../../widgets/admin_drawer.dart';

class LaporanPerbandinganPage extends ConsumerWidget {
  const LaporanPerbandinganPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    Map parameterPerbandingan = ref.watch(parameterPerbandinganReportProvider);
    DateTimeRange date = ref.watch(parameterPerbandinganReportProvider)['date'] as DateTimeRange;
    String outlet = ref.watch(parameterPerbandinganReportProvider)['outlet_id'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Perbandingan')),
      drawer: DrawerAdmin(active: 10, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(parameterPerbandinganReportProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ref.watch(futureGetOutletsProvider).when(
                  data: (result) {
                    List<Map> data = result['data'];
                    return DropdownButtonFormField(
                        items: data.map((e) => DropdownMenuItem(value: e, child: Text(e['nama']))).toList(),
                        value: data.first,
                        onChanged: (value) {
                          ref.read(parameterPerbandinganReportProvider.notifier).state = {
                            'date': date,
                            'outlet_id': value!['id'],
                          };
                        });
                  },
                  error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
                  loading: () => Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Container(height: 55, color: Colors.black)),
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
                              ref.read(parameterPerbandinganReportProvider.notifier).state = {
                                'date': dateTemp!,
                                'outlet_id': outlet,
                              };
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
                              ref.read(parameterPerbandinganReportProvider.notifier).state = {
                                'date': dateTemp!,
                                'outlet_id': outlet,
                              };
                            } catch (e) {}
                          },
                        ))),
              ],
            ),
            ref.watch(futurePerbandinganReportProvider(parameterPerbandingan)).when(
                  data: (data) {
                    List<Map> dataGrafik = [];
                    for (var element in data) {
                      dataGrafik.add({
                        'label': DateFormat("d MMMM yyyy", "id_ID").format(DateTime.parse(element['waktu']!)),
                        'value1': int.parse(element['total_device']!),
                        'value2': int.parse(element['total_kasir']!)
                      });
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
                            title: Text(data[i]['user_nama']!),
                            subtitle: Text('${DateFormat("d MMMM yyyy", "id_ID").format(DateTime.parse(data[i]['waktu']!))}\nSelisih : ${numberFormat.format(int.parse(data[i]['selisih']!))}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: const Color(0xff3943B7), borderRadius: BorderRadius.circular(10)),
                                  child: Text('AI Device : ${numberFormat.format(int.parse(data[i]['total_device']!))}', style: const TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: const Color(0xff159600), borderRadius: BorderRadius.circular(10)),
                                  child: Text('Kasir : ${numberFormat.format(int.parse(data[i]['total_kasir']!))}', style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          )),
                      ],
                    );
                  },
                  error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
                  loading: () => Column(
                    children: [
                      Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 200, width: size.width - 40))),
                      Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 300, width: size.width - 40))),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
