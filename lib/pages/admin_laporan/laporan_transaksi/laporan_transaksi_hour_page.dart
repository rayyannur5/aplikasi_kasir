import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/print_page/detail_transaksi_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/navigator.dart';

class AdminLaporanTransaksiJamPage extends ConsumerWidget {
  final String day;
  const AdminLaporanTransaksiJamPage({super.key, required this.day});

  @override
  Widget build(BuildContext context, ref) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Ringkasan Transaksi")),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureHourGetTransactionProvider);
        },
        child: ref.watch(futureHourGetTransactionProvider(day)).when(
              skipLoadingOnRefresh: false,
              data: (data) {
                List<Map> dataGrafik = [];
                for (var element in data) {
                  dataGrafik.add({
                    'label': element['jam'],
                    'value': element['amount'],
                  });
                }
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    CustomChartWithLabel(data: dataGrafik),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(data[index]['jam'], style: TextStyles.h2),
                          subtitle: Text(data[index]['outlet_nama']),
                          trailing: Container(
                            height: double.infinity,
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                            child: Text(numberFormat.format(data[index]['amount']), style: TextStyles.h2Light),
                          ),
                          onTap: () => Future.delayed(const Duration(milliseconds: 200), () => push(context, DeetailTransaksi(id: data[index]['id']))),
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) => const Center(
                child: Text('Gagal Ambil Data'),
              ),
              loading: () => Center(
                child: LottieBuilder.asset('assets/lotties/loading.json'),
              ),
            ),
      ),
    );
  }
}
