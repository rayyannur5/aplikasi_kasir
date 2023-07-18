import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_transaksi/laporan_transaksi_hour_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class AdminLaporanTransaksiHariPage extends ConsumerWidget {
  final String month;
  const AdminLaporanTransaksiHariPage({super.key, required this.month});

  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Ringkasan Transaksi")),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureDayGetTransactionProvider);
        },
        child: ref.watch(futureDayGetTransactionProvider(month)).when(
              skipLoadingOnRefresh: false,
              data: (data) {
                List<Map> dataGrafik = [];
                data.forEach((element) {
                  dataGrafik.add({
                    'label': element['hari'],
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
                          title: Text(data[index]['hari'], style: TextStyles.h2),
                          subtitle: Text("${numberFormat.format(data[index]['transaksi'])} Transaksi"),
                          onTap: () => Future.delayed(Duration(milliseconds: 200), () => push(context, AdminLaporanTransaksiJamPage(day: data[index]['hari']))),
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
