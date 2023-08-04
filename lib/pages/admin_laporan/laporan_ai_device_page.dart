import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class LaporanAIDevicePage extends ConsumerWidget {
  const LaporanAIDevicePage({super.key});
  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;

    Map parameterAI = ref.watch(parameterReportAIProvider);
    DateTimeRange date = ref.watch(parameterReportAIProvider)['date'] as DateTimeRange;
    String outlet = ref.watch(parameterReportAIProvider)['outlet_id'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan AI Device')),
      drawer: DrawerAdmin(active: 8, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureReportAIDeviceProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ref.watch(futureGetOutletsProvider(1)).when(
                  data: (data) => DropdownButtonFormField(
                      items: data.map((e) => DropdownMenuItem(value: e, child: Text(e['nama']))).toList(),
                      value: data.first,
                      onChanged: (value) {
                        ref.read(parameterReportAIProvider.notifier).state = {
                          'date': date,
                          'outlet_id': value!['id'],
                        };
                      }),
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
                              ref.read(parameterReportAIProvider.notifier).state = {
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
                              ref.read(parameterReportAIProvider.notifier).state = {
                                'date': dateTemp!,
                                'outlet_id': outlet,
                              };
                            } catch (e) {}
                          },
                        ))),
              ],
            ),
            const SizedBox(height: 10),
            ref.watch(futureReportAIDeviceProvider(parameterAI)).when(
                  skipLoadingOnRefresh: false,
                  data: (data) {
                    List<Map> dataGrafik = [];
                    var dataMap = data['data'] as Map;
                    dataMap.forEach(
                      (key, value) {
                        dataGrafik.add({
                          'label': key,
                          'value': value,
                        });
                      },
                    );
                    return Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CustomChartWithLabel(data: dataGrafik),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['device_nama']),
                                const SizedBox(height: 10),
                                Column(
                                  children: data['data']
                                      .entries
                                      .map<Widget>((e) => Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text(e.key.toString(), style: TextStyles.pBold), Text("${e.value.toString()} Ban")],
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                )
          ],
        ),
      ),
    );
  }
}
