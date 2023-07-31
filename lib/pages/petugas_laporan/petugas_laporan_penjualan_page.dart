import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/widgets/petugas_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/formatter.dart';
import '../../utils/navigator.dart';
import '../../utils/textstyles.dart';
import '../../widgets/custom_chart_with_label.dart';
import '../print_page/detail_transaksi_page.dart';

class PetugasLaporanPenjualanPage extends StatelessWidget {
  PetugasLaporanPenjualanPage({super.key});
  final day = DateTimeRange(start: DateTime.now(), end: DateTime.now());
  final week = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now());
  final month = DateTimeRange(start: DateTime.now().subtract(const Duration(days: 30)), end: DateTime.now());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: DrawerPetugas(size: size, active: 3),
        appBar: appBar(),
        body: TabBarView(
          children: [
            page(context, day, size, MediaQuery.of(context).viewPadding.top),
            page(context, week, size, MediaQuery.of(context).viewPadding.top),
            page(context, month, size, MediaQuery.of(context).viewPadding.top),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Laporan Penjualan'),
      bottom: TabBar(
        labelColor: Colors.white,
        onTap: (value) {
          if (value == 0) {}
        },
        tabs: const [
          Tab(text: 'Hari Ini'),
          Tab(text: '1 Minggu'),
          Tab(text: '1 Bulan'),
        ],
      ),
    );
  }

  Widget page(context, range, size, statusBarHeight) {
    return StatefulBuilder(
      builder: (context, setState) => FutureBuilder(
        future: Services().getPetugasLaporanPenjualan(range),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      height: 200,
                      width: size.width,
                      margin: const EdgeInsets.all(20),
                      color: Colors.black,
                    )),
                Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      height: 50,
                      width: size.width,
                      margin: const EdgeInsets.all(20),
                      color: Colors.black,
                    )),
              ],
            );
          }
          List data = snapshot.data!;
          if (data.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                children: [Image.asset('assets/images/empty.png')],
              ),
            );
          }
          List<Map> dataGrafik = [];
          for (var element in data) {
            dataGrafik.add({
              'label': element['jam'],
              'value': element['amount'],
            });
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomChartWithLabel(data: dataGrafik),
              ),
              SizedBox(
                height: size.height - appBar().preferredSize.height - statusBarHeight - 240,
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
