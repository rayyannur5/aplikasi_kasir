import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'laporan_transaksi_month_page.dart';

class AdminLaporanTransaksiPage extends ConsumerWidget {
  const AdminLaporanTransaksiPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Ringkasan Transaksi")),
      drawer: DrawerAdmin(active: 9, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureYearGetTransactionProvider);
        },
        child: ref.watch(futureYearGetTransactionProvider).when(
              skipLoadingOnRefresh: false,
              data: (data) => ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: data.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(data[index]['tahun'], style: TextStyles.h2),
                    subtitle: Text("${numberFormat.format(data[index]['transaksi'])} Transaksi"),
                    onTap: () => Future.delayed(Duration(milliseconds: 200), () => push(context, AdminLaporanTransaksiBulanPage(year: data[index]['tahun']))),
                  ),
                ),
              ),
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
