import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Services {
  final String _uri = "";

  static login(email, password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static createTransactions(data) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static addItems(icon, name, harga, kategori) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static addShift(nama, start, end) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static updateShift(nama, start, end) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static checkDevice(id) async {
    await Future.delayed(const Duration(seconds: 1));
    if (id == "XaXadd") {
      return {
        'id': 'XaXadd',
        'nama': 'Perangkat SPBU Generator',
      };
    } else {
      return null;
    }
  }

  static addOutlet(dataDevice, nama) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<int> getCountDeviceTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(1000);
  }

  Future<int> getCountCashierTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(100);
  }

  Future<int> getOpenedOutlets() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(10);
  }

  Future<int> getActivedEmployees() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(10);
  }

  Future<Map> getOmsetComparison() async {
    await Future.delayed(const Duration(seconds: 1));
    var hasil = {'kasir': '10.000', 'device': '10.000'};
    return hasil;
  }

  Future<List<double>> getChartTodayTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    List<double> hasil = [
      0,
      0,
      0,
      0,
      5,
      6,
      2,
      8,
      10,
      3,
      6,
      0,
      7,
      9,
      11,
      1,
      3,
      4,
      0,
      0,
      0,
      0,
      0,
      0,
    ];
    return hasil;
  }

  Future<List<Map>> getItems(outletId) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Tambah Angin Motor',
        'kategori': '1',
        'harga': '3000',
        'icon': '1',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '2',
        'nama': 'Tambah Angin Mobil',
        'kategori': '2',
        'harga': '5000',
        'icon': '1',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '3',
        'nama': 'Ganti Angin Motor',
        'kategori': '1',
        'harga': '7000',
        'icon': '2',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '4',
        'nama': 'Ganti Angin Mobil',
        'kategori': '2',
        'harga': '9000',
        'icon': '2',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '5',
        'nama': 'Tambal Ban Motor',
        'kategori': '1',
        'harga': '10000',
        'icon': '3',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '6',
        'nama': 'Tambal Ban Mobil',
        'kategori': '2',
        'harga': '20000',
        'icon': '3',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
    ];

    hasil = hasil.where((element) => element['outlet_id'] == outletId.toString()).toList();

    return hasil;
  }

  Future<List<Map>> getKategories() async {
    await Future.delayed(const Duration(seconds: 1));
    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Motor',
      },
      {
        'id': '2',
        'nama': 'Mobil',
      },
      {
        'id': '3',
        'nama': 'Lain - lain',
      },
    ];
    return hasil;
  }

  Future<List<Map>> getEmployees(String keyword) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Budi Santoso',
        'email': 'budi@gmail.com',
      },
      {
        'id': '2',
        'nama': 'Panji',
        'email': 'panji@gmail.com',
      },
      {
        'id': '3',
        'nama': 'Rendi',
        'email': 'rendi@gmail.com',
      },
    ];

    hasil = hasil.where((element) => element['nama'].toString().toLowerCase().contains(keyword.toLowerCase())).toList();

    return hasil;
  }

  Future<String> getKodeReferral() async {
    await Future.delayed(const Duration(seconds: 1));

    return "Axd679";
  }

  Future<List<Map>> getOutlets(String keyword) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Outlet 1',
        'mesin_id': 'asRf2',
      },
      {
        'id': '2',
        'nama': 'Outlet 2',
        'mesin_id': 'asRf2',
      },
      {
        'id': '3',
        'nama': 'Outlet 3',
        'mesin_id': 'asRf2',
      },
    ];

    hasil = hasil.where((element) => element['nama'].toString().toLowerCase().contains(keyword.toLowerCase())).toList();

    return hasil;
  }

  Future<List<Map>> getShift() async {
    await Future.delayed(const Duration(seconds: 1));
    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Shift 1',
        'start': '00:00',
        'end': '09:59',
      },
      {
        'id': '2',
        'nama': 'Shift 2',
        'start': '10:00',
        'end': '15:59',
      },
      {
        'id': '3',
        'nama': 'Shift 3',
        'start': '16:00',
        'end': '21:59',
      },
    ];
    return hasil;
  }

  Future<Map> getAIDevice(Map data) async {
    print(data);
    String formattedBeginDate = DateFormat('yyyy-MM-dd').format(data['date'].start);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(data['date'].end);
    await Future.delayed(const Duration(seconds: 1));
    Map hasil = {
      'id': '1',
      'data': {
        'Tambah Angin Motor': 30,
        'Isi Baru Motor': 20,
        'Tambah Angin Mobil': 34,
        'Isi Baru Mobil': 12,
        'Pas Motor': 6,
        'Pas Mobil': 6,
        'Kurangi Motor': 0,
        'Kurangi Mobil': 0,
        'Pause Motor': 0,
        'Pause Mobil': 0,
        'Error Motor': 0,
        'Error Mobil': 0,
      },
      'outlet_id': '1',
      'outlet_nama': 'Outlet 1',
      'device_id': 'XaXadd',
      'device_nama': 'Perangkat SPBU Generator'
    };

    return hasil;
  }

  Future<List> getYearReportTransaction() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'tahun': '2023',
        'transaksi': 1000000,
      }
    ];
  }

  Future<List> getMonthReportTransaction(String year) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'bulan': 'Januari 2023',
        'transaksi': 1000000,
      },
      {
        'bulan': 'Juli 2023',
        'transaksi': 1000000,
      },
      {
        'bulan': 'Agustus 2023',
        'transaksi': 1000000,
      },
      {
        'bulan': 'September 2023',
        'transaksi': 1000000,
      },
      {
        'bulan': 'November 2023',
        'transaksi': 1000000,
      },
    ];
  }

  Future<List> getDayReportTransaction(String month) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'hari': '12 Juli 2023',
        'transaksi': 599,
      },
      {
        'hari': '13 Juli 2023',
        'transaksi': 678,
      },
      {
        'hari': '14 Juli 2023',
        'transaksi': 456,
      },
      {
        'hari': '15 Juli 2023',
        'transaksi': 876,
      },
      {
        'hari': '16 Juli 2023',
        'transaksi': 789,
      },
      {
        'hari': '17 Juli 2023',
        'transaksi': 900,
      },
      {
        'hari': '18 Juli 2023',
        'transaksi': 1000,
      },
      {
        'hari': '19 Juli 2023',
        'transaksi': 200,
      },
      {
        'hari': '20 Juli 2023',
        'transaksi': 300,
      },
      {
        'hari': '21 Juli 2023',
        'transaksi': 400,
      },
    ];
  }

  Future<List> getHourReportTransaction(String day) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'jam': '12:00',
        'transaksi': 599,
        'outlet_nama': 'Outlet 1',
      },
      {
        'jam': '13:00',
        'transaksi': 678,
        'outlet_nama': 'Outlet 1',
      },
      {
        'jam': '23:00',
        'transaksi': 456,
        'outlet_nama': 'Outlet 1',
      },
      {
        'jam': '23:50',
        'transaksi': 876,
        'outlet_nama': 'Outlet 1',
      },
    ];
  }
}
