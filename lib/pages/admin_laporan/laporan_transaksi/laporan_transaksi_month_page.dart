import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_transaksi/laporan_transaksi_day_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../api/services.dart';

class AdminLaporanTransaksiBulanPage extends StatefulWidget {
  final String year;
  const AdminLaporanTransaksiBulanPage({super.key, required this.year});

  @override
  State<AdminLaporanTransaksiBulanPage> createState() => _AdminLaporanTransaksiBulanPageState();
}

class _AdminLaporanTransaksiBulanPageState extends State<AdminLaporanTransaksiBulanPage> {
  @override
  Widget build(BuildContext context) {
    Map bulan = {
      '1': 'Januari ${widget.year}',
      '2': 'Februari ${widget.year}',
      '3': 'Maret ${widget.year}',
      '4': 'April ${widget.year}',
      '5': 'Mei ${widget.year}',
      '6': 'Juni ${widget.year}',
      '7': 'Juli ${widget.year}',
      '8': 'Agustus ${widget.year}',
      '9': 'September ${widget.year}',
      '10': 'Oktober ${widget.year}',
      '11': 'November ${widget.year}',
      '12': 'Desember ${widget.year}',
    };
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Ringkasan Transaksi")),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: Services.getMonthReportTransaction(widget.year),
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
                  'label': bulan[element['bulan']],
                  'value': int.parse(element['transaksi']),
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
                        title: Text(bulan[data[index]['bulan']], style: TextStyles.h2),
                        subtitle: Text("${numberFormat.format(int.parse(data[index]['transaksi']))} Transaksi"),
                        onTap: () => Future.delayed(
                          const Duration(milliseconds: 200),
                          () => push(
                            context,
                            AdminLaporanTransaksiHariPage(month: data[index]['bulan'], year: widget.year),
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
