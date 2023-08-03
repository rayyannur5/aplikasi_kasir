import 'dart:math';

import 'package:aplikasi_kasir/api/local.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Services {
  final String baseUrl = "https://fit-vaguely-sloth.ngrok-free.app/aplikasi_kasir";
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://fit-vaguely-sloth.ngrok-free.app/server_aplikasi_kasir',
    ),
  );

  static login(email, password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@mail.com') {
      await Local.setUserData({
        'user_nama': 'Administrator',
        'user_email': 'admin@mail.com',
        'user_role': 'admin',
        'user_phone': '6285215955155',
      });
      return true;
    } else if (email == 'user@mail.com') {
      await Local.setUserData({
        'user_nama': 'User Biasa',
        'user_email': 'user@mail.com',
        'user_role': 'user',
        'user_phone': '6285215955155',
      });
      return true;
    }
    return false;
  }

  static Future<Map> getUserInformation() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'nama': 'Rayyan Nur Fauzan',
      'email': 'rayyannur5@gmail.com',
      'role': 'admin',
      'phone': '6285215955155',
    };
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

  register() async {
    Map<String, dynamic> registerData = await Local.getRegisterData();
    try {
      if (await Local.getRegisterMode() == 'admin') {
        var resp = await dio.post(Uri.decodeFull('/admin/auth/register.php'), data: FormData.fromMap(registerData));
        if (resp.data['success']) {
          await Local.setUserData(resp.data['data'][0]);
          await Local.setReceiptData(resp.data['data'][0]);
        }
        return resp.data;
      } else {}
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  checkDevice(id) async {
    var resp = await dio.get(
      Uri.encodeFull("/admin/devices/check.php"),
      queryParameters: {
        'device_id': id,
      },
    );

    if (resp.data['success']) {
      if (resp.data['data'][0]['id'] == id) {
        return resp.data['data'][0];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  addOutlet() async {
    Map<String, dynamic> addOutletData = await Local.getAddOutletData();
    try {
      var resp = await dio.post(Uri.encodeFull('/admin/stores/create.php'), data: FormData.fromMap(addOutletData));
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
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
        'lat': '-7.316817334144685',
        'lon': '112.7254388237554',
        'addr': 'MPMG+75M, Ketintang, Kec. Gayungan, Surabaya, Jawa Timur 60231',
      },
      {
        'id': '2',
        'nama': 'Outlet 2',
        'mesin_id': 'asRf2',
        'lat': '-7.316817334144685',
        'lon': '112.7254388237554',
        'addr': 'MPMG+75M, Ketintang, Kec. Gayungan, Surabaya, Jawa Timur 60231',
      },
      {
        'id': '3',
        'nama': 'Outlet 3',
        'mesin_id': 'asRf2',
        'lat': '-7.316817334144685',
        'lon': '112.7254388237554',
        'addr': 'MPMG+75M, Ketintang, Kec. Gayungan, Surabaya, Jawa Timur 60231',
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
    // String formattedBeginDate = DateFormat('yyyy-MM-dd').format(data['date'].start);
    // String formattedEndDate = DateFormat('yyyy-MM-dd').format(data['date'].end);
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
        'id': '1',
        'jam': '12:00',
        'amount': 10000,
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '2',
        'jam': '13:00',
        'amount': 10000,
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '3',
        'jam': '23:00',
        'amount': 10000,
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '4',
        'jam': '23:50',
        'amount': 10000,
        'outlet_nama': 'Outlet 1',
      },
    ];
  }

  Future getDetailTransaction(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': '1',
      'outlet_id': '1',
      'outlet_nama': 'Outlet 1',
      'outlet_pesan': 'Terimakasih sudah belanja di toko kami',
      'user_id': '34',
      'user_nama': 'Budi Santoso',
      'data': [
        {
          'item_nama': 'Tambah Angin Motor',
          'item_harga': '10000',
          'item_count': '3',
        },
        {
          'item_nama': 'Tambah Angin Mobil',
          'item_harga': '10000',
          'item_count': '2',
        },
      ],
      'created_at': '2023-07-14 23:48:00',
    };
  }

  Future<List<Map<String, String>>> getPerbandinganReport(Map data) async {
    // String formattedBeginDate = DateFormat('yyyy-MM-dd').format(data['date'].start);
    // String formattedEndDate = DateFormat('yyyy-MM-dd').format(data['date'].end);
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'waktu': '2023-07-14',
        'user_nama': 'Budi Santoso',
        'total_device': '10000000',
        'total_kasir': '9000000',
        'selisih': '1000000',
      },
      {
        'waktu': '2023-07-14',
        'user_nama': 'Budi Santoso',
        'total_device': '10000000',
        'total_kasir': '9000000',
        'selisih': '1000000',
      },
      {
        'waktu': '2023-07-14',
        'user_nama': 'Budi Santoso',
        'total_device': '8000000',
        'total_kasir': '9000000',
        'selisih': '1000000',
      },
    ];
  }

  Future getLaporanPetugas(DateTimeRange range) async {
    await Future.delayed(const Duration(seconds: 1));

    // return [];
    return [
      {
        'user_id': '1',
        'user_nama': 'Budi Santoso',
        'created_at': '2023-07-14 23:48:00',
        'updated_at': '2023-07-14 24:00:00',
        'image_in': 'https://picsum.photos/200/300',
        'image_out': 'https://picsum.photos/200/300',
        'lat_in': '-7.31686186932247',
        'lon_in': '112.72543698655583',
        'addr_in': 'MPMG+75M, Ketintang, Kec. Gayungan, Surabaya, Jawa Timur 60231',
        'lat_out': '-7.316906755372916',
        'lon_out': '112.72549852076374',
        'addr_out': 'MPMG+75M, Ketintang, Kec. Gayungan, Surabaya, Jawa Timur 60231',
        'omset': '1000000',
        'shift': '2',
        'keterangan': 'Tepat Waktu',
      },
    ];
  }

  Future<List> getPetugasLaporanPenjualan(DateTimeRange range) async {
    await Future.delayed(const Duration(seconds: 1));
    if (DateFormat('y-MM-d HH:m').format(range.start) == DateFormat('y-MM-d HH:m').format(range.end)) {
      return [
        {
          'id': '1',
          'jam': '12:00',
          'amount': 10000,
          'outlet_nama': 'Outlet 1',
        },
        {
          'id': '2',
          'jam': '13:00',
          'amount': 10000,
          'outlet_nama': 'Outlet 1',
        },
      ];
    } else {
      return [
        {
          'id': '1',
          'jam': '12:00',
          'amount': 10000,
          'outlet_nama': 'Outlet 1',
        },
        {
          'id': '2',
          'jam': '13:00',
          'amount': 10000,
          'outlet_nama': 'Outlet 1',
        },
        {
          'id': '3',
          'jam': '23:00',
          'amount': 10000,
          'outlet_nama': 'Outlet 1',
        },
        {
          'id': '4',
          'jam': '23:50',
          'amount': 10000,
          'outlet_nama': 'Outlet 1',
        },
      ];
    }
  }

  Future<int> getTabungan() async {
    await Future.delayed(const Duration(seconds: 1));
    return 100000;
  }

  Future<List<Map>> getListSetoran(DateTimeRange range) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'date': '2023-07-14 23:48:00',
        'total': '100000',
      },
      {
        'date': '2023-07-14 23:48:00',
        'total': '100000',
      },
      {
        'date': '2023-07-14 23:48:00',
        'total': '100000',
      },
      {
        'date': '2023-07-14 23:48:00',
        'total': '100000',
      },
      {
        'date': '2023-07-14 23:48:00',
        'total': '100000',
      },
      {
        'date': '2023-07-14 23:48:00',
        'total': '100000',
      },
    ];
  }
}
