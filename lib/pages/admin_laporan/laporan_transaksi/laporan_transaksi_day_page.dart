import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_transaksi/laporan_transaksi_hour_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../api/services.dart';

class AdminLaporanTransaksiHariPage extends StatefulWidget {
  const AdminLaporanTransaksiHariPage({super.key});

  @override
  State<AdminLaporanTransaksiHariPage> createState() => _AdminLaporanTransaksiHariPageState();
}

class _AdminLaporanTransaksiHariPageState extends State<AdminLaporanTransaksiHariPage> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Ringkasan Transaksi")),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: Services.getDayReportTransaction(DateTime.now()),
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
              List<Map> dataGrafik = [];
              for (var element in data) {
                dataGrafik.add({
                  'label': "  " + DateFormat("d MMMM yyyy", "id_ID").format(DateTime.parse(element['hari'])),
                  'value': int.parse(element['transaksi']),
                });
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  CustomChartWithLabel(data: dataGrafik),
                  Divider(),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(DateFormat("d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['hari'])), style: TextStyles.h2),
                        subtitle: Text("${numberFormat.format(int.parse(data[index]['transaksi']))} Transaksi"),
                        trailing: Icon(Icons.navigate_next),
                        onTap: () => Future.delayed(
                          const Duration(milliseconds: 200),
                          () => push(
                            context,
                            AdminLaporanTransaksiJamPage(date: data[index]['hari']),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
