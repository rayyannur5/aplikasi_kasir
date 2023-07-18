import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_transaksi/laporan_transaksi_day_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class AdminLaporanTransaksiBulanPage extends ConsumerWidget {
  final String year;
  const AdminLaporanTransaksiBulanPage({super.key, required this.year});

  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Ringkasan Transaksi")),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureMonthGetTransactionProvider);
        },
        child: ref.watch(futureMonthGetTransactionProvider(year)).when(
              skipLoadingOnRefresh: false,
              data: (data) {
                List<Map> dataGrafik = [];
                data.forEach((element) {
                  dataGrafik.add({
                    'label': element['bulan'],
                    'value': element['transaksi'],
                  });
                });
                return ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    CustomChartWithLabel(data: dataGrafik),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(data[index]['bulan'], style: TextStyles.h2),
                          subtitle: Text("${numberFormat.format(data[index]['transaksi'])} Transaksi"),
                          onTap: () => Future.delayed(
                              Duration(milliseconds: 200),
                              () => push(
                                  context,
                                  AdminLaporanTransaksiHariPage(
                                    month: data[index]['bulan'],
                                  ))),
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
