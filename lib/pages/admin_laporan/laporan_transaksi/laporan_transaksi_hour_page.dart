import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/print_page/detail_transaksi_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/navigator.dart';

class AdminLaporanTransaksiJamPage extends ConsumerWidget {
  final String date;
  const AdminLaporanTransaksiJamPage({super.key, required this.date});

  @override
  Widget build(BuildContext context, ref) {
    // var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text("Ringkasan Transaksi")),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: FutureBuilder(
            future: Services.getHourReportTransaction(date),
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
                    'label': DateFormat("    HH:mm", "id_ID").format(DateTime.parse(element['created_at'])),
                    'value': int.parse(element['paid']),
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
                          title: Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data[index]['created_at'])), style: TextStyles.h2),
                          subtitle: Text(data[index]['store']),
                          trailing: Container(
                            height: double.infinity,
                            width: 100,
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                            child: Text(numberFormat.format(int.parse(data[index]['paid'])), style: TextStyles.h2Light),
                          ),
                          onTap: () => Future.delayed(const Duration(milliseconds: 200), () => push(context, DetailTransaksi(id: data[index]['id']))),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ));
  }
}
