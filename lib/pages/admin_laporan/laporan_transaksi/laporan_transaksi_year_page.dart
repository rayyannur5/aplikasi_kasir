import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_transaksi/laporan_transaksi_day_page.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_transaksi/laporan_transaksi_hour_page.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.calendar_view_day),
                  title: Text('Transaksi Hari Ini'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 200));
                    push(context, AdminLaporanTransaksiJamPage(date: DateTime.now().toString().substring(0, 10)));
                  },
                ),
              ),
              Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.calendar_view_week),
                  title: Text('Transaksi 7 Hari Terakhir'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 200));
                    push(context, AdminLaporanTransaksiHariPage());
                  },
                ),
              ),
              Card(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.calendar_view_month),
                  title: Text('Transaksi Bulan Ini'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () async {
                    push(context, AdminLaporanTransaksiBulanPage());
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
