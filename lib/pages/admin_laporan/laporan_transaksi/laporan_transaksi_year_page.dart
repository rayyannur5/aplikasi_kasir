import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'laporan_transaksi_month_page.dart';

class AdminLaporanTransaksiPage extends StatefulWidget {
  const AdminLaporanTransaksiPage({super.key});

  @override
  State<AdminLaporanTransaksiPage> createState() => _AdminLaporanTransaksiPageState();
}

class _AdminLaporanTransaksiPageState extends State<AdminLaporanTransaksiPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Ringkasan Transaksi")),
      drawer: DrawerAdmin(active: 9, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: Services.getYearReportTransaction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
            } else if (!snapshot.data['success']) {
              return ListView(
                children: [
                  Image.asset('assets/images/error.png'),
                  Text(snapshot.data['errors']),
                ],
              );
            } else {
              List data = snapshot.data['data'];
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: data.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(data[index]['tahun'], style: TextStyles.h2),
                    subtitle: Text("${numberFormat.format(int.parse(data[index]['transaksi']))} Transaksi"),
                    onTap: () => Future.delayed(const Duration(milliseconds: 200), () => push(context, AdminLaporanTransaksiBulanPage(year: data[index]['tahun']))),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
