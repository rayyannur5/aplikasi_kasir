import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aplikasi_kasir/api/local.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class Services {
  static final dio = Dio(
    BaseOptions(
      baseUrl: 'https://new.mirovtech.id/v1',
      // baseUrl: 'https://fit-vaguely-sloth.ngrok-free.app/server_aplikasi_kasir',
    ),
  );

  static login(email, password) async {
    try {
      var resp = await dio.post(Uri.encodeFull('/auth/login.php'), data: FormData.fromMap({'email': email, 'password': password}));
      if (resp.data['success']) {
        await Local.setUserData(resp.data['data'][0]);
        await Local.setReceiptData(resp.data['data'][0]);
        await Local.setLogin(true);
      }
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getUserInformation() async {
    try {
      var userData = await Local.getUserData();
      var resp = await dio.post(Uri.encodeFull('/auth/user.php'), data: FormData.fromMap({'email': userData['user_email']}));
      if (resp.data['success']) {
        await Local.setUserData(resp.data['data'][0]);
        await Local.setReceiptData(resp.data['data'][0]);
      }
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static createTransactions(data) async {
    try {
      var userData = await Local.getUserData();
      if (userData['user_role'] == 'admin') {
        var res = await dio.post('/katalog/transactions/createadmin.php', data: FormData.fromMap({'data': jsonEncode(data)}));
        return res.data;
      } else {
        var res = await dio.post('/katalog/transactions/create.php', data: FormData.fromMap({'pegawai_id': userData['user_id'], 'data': jsonEncode(data)}));
        return res.data;
      }
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  // MANAJEMEN LAYANAN
  Future<Map> getItems() async {
    try {
      Map<String, dynamic> userData = await Local.getUserData();
      var res = await dio.get(Uri.encodeFull('/admin/products/get.php'), queryParameters: {'admin_id': userData['user_id']});
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static addItems(icon, name) async {
    try {
      Map<String, dynamic> userData = await Local.getUserData();
      var res = await dio.post(Uri.encodeFull("/admin/products/create.php"), data: FormData.fromMap({'admin_id': userData['user_id'], 'icon': icon, 'name': name}));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static editItems(id, icon, name) async {
    try {
      var res = await dio.post(Uri.encodeFull("/admin/products/update.php/$id"), data: FormData.fromMap({'icon': icon, 'name': name}));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static deleteItems(id) async {
    try {
      var res = await dio.get(Uri.encodeFull("/admin/products/delete.php/$id"));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getOutlets() async {
    try {
      var userData = await Local.getUserData();
      var loginData = await Local.getLogin();

      if (loginData['role'] == 'admin') {
        var res = await dio.get(Uri.encodeFull("/admin/stores/get.php"), queryParameters: {'admin_id': userData['user_id']});
        return res.data;
      } else {
        var res = await dio.get(Uri.encodeFull("/pegawai/stores/get.php"), queryParameters: {'pegawai_id': userData['user_id']});
        return res.data;
      }
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getPrices(storeId) async {
    try {
      var res = await dio.get(Uri.encodeFull("/admin/prices/get.php"), queryParameters: {'store_id': storeId});
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static createPrice(storeId, productId, price) async {
    try {
      var res = await dio.post(Uri.encodeFull("/admin/prices/create.php"), data: FormData.fromMap({'store_id': storeId, 'product_id': productId, 'price': price}));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static updatePrice(id, price) async {
    try {
      var res = await dio.post(Uri.encodeFull("/admin/prices/update.php/$id"), data: FormData.fromMap({'price': price}));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static verifyPegawai(pegawaiId, value) async {
    try {
      var res = await dio.post("/admin/pegawais/verify.php/$pegawaiId", data: FormData.fromMap({'value': value}));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  register() async {
    Map<String, dynamic> registerData = await Local.getRegisterData();
    try {
      if (await Local.getRegisterMode() == 'admin') {
        var resp = await dio.post('/admin/auth/register.php', data: FormData.fromMap(registerData));
        if (resp.data['success']) {
          await Local.setUserData(resp.data['data'][0]);
          await Local.setReceiptData(resp.data['data'][0]);
          await Local.setCityId(resp.data['data'][0]['first_city_id']);
          await Local.setLogin(true);
        }
        return resp.data;
      } else {
        var resp = await dio.post('/pegawai/auth/register.php', data: FormData.fromMap(registerData));
        if (resp.data['success']) {
          await Local.setUserData(resp.data['data'][0]);
          await Local.setReceiptData(resp.data['data'][0]);
          await Local.setCityId(resp.data['data'][0]['city_id']);
          await Local.setLogin(true);
        }
        return resp.data;
      }
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
      var resp = await dio.post('/admin/stores/create.php', data: FormData.fromMap(addOutletData));
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static updateOutlet(id, cityId, name, lat, lon) async {
    try {
      var resp = await dio.post('/admin/stores/update.php/$id', data: FormData.fromMap({'city_id': cityId, 'name': name, 'lat': lat, 'lon': lon}));
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getEmployees() async {
    try {
      var userData = await Local.getUserData();
      var res = await dio.get(Uri.encodeFull('/admin/pegawais/get.php'), queryParameters: {'admin_id': userData['user_id']});
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future<Map> getKodeReferral() async {
    try {
      var userData = await Local.getUserData();
      var res = await dio.get(Uri.encodeFull('/admin/pegawais/refferal.php'), queryParameters: {'admin_id': userData['user_id']});
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future<Map> getCities() async {
    try {
      var userData = await Local.getUserData();
      var res = await dio.get('/admin/cities/get.php', queryParameters: {'admin_id': userData['user_id']});
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future addCities(name) async {
    try {
      var userData = await Local.getUserData();
      var res = await dio.post('/admin/cities/create.php', data: FormData.fromMap({'admin_id': userData['user_id'], 'name': name}));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future updateCities(id, name) async {
    try {
      var res = await dio.post('/admin/cities/update.php/$id', data: FormData.fromMap({'name': name}));
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getShift() async {
    try {
      var userData = await Local.getUserData();
      var res = await dio.get('/admin/shifts/get.php', queryParameters: {'admin_id': userData['user_id']});
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static updateShift(id, time, shift) async {
    try {
      if (shift == 1) {
        var resp = await dio.post('/admin/shifts/update.php/$id', data: FormData.fromMap({'time_s1': time}));
        return resp.data;
      } else if (shift == 2) {
        var resp = await dio.post('/admin/shifts/update.php/$id', data: FormData.fromMap({'time_s2': time}));
        return resp.data;
      } else {
        var resp = await dio.post('/admin/shifts/update.php/$id', data: FormData.fromMap({'time_s3': time}));
        return resp.data;
      }
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getKatalogItem(storeId) async {
    try {
      var resp = await dio.get('/katalog/product/get.php?store_id=$storeId');
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future detailAbsensi(id) async {
    try {
      var resp = await dio.get('/pegawai/laporan/absensi_detail.php/$id');
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getCountDeviceTransactions() async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/dashboard/count_device.php', queryParameters: {'admin_id': userData['user_id']});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getCountCashierTransactions() async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/dashboard/count_cashier.php', queryParameters: {'admin_id': userData['user_id']});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getOpenedOutlets() async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/dashboard/outlet_opened.php', queryParameters: {'admin_id': userData['user_id']});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getActivedEmployees() async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/dashboard/actived_employee.php', queryParameters: {'admin_id': userData['user_id']});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getOmsetComparison() async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/dashboard/omset_comparison.php', queryParameters: {'admin_id': userData['user_id']});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getChartTodayTransactions() async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/dashboard/chart_today.php', queryParameters: {'admin_id': userData['user_id']});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
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

  static Future getYearReportTransaction() async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/laporan/transaksi_tahun.php', queryParameters: {'admin_id': userData['user_id']});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getMonthReportTransaction(String year) async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/laporan/transaksi_bulan.php', queryParameters: {'admin_id': userData['user_id'], 'year': year});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getDayReportTransaction(String month, String year) async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/laporan/transaksi_hari.php', queryParameters: {'admin_id': userData['user_id'], 'month': month, 'year': year});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getHourReportTransaction(String date) async {
    try {
      var userData = await Local.getUserData();
      var response = await dio.get('/admin/laporan/transaksi_jam.php', queryParameters: {'admin_id': userData['user_id'], 'date': date});
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getDetailTransaction(String id) async {
    try {
      print("DETAIL TRANSAKSI : $id");
      var res = await dio.get('/pegawai/laporan/penjualan_detail.php/$id');
      return res.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getPerbandinganReport(DateTimeRange date, selectedOutlet) async {
    String formattedBeginDate = DateFormat('yyyy-MM-dd').format(date.start);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(date.end);

    try {
      Map<String, dynamic> params = {
        'store_id': selectedOutlet,
        'start_date': formattedBeginDate,
        'end_date': formattedEndDate,
      };
      var response = await dio.post("/admin/laporan/perbandingan.php", queryParameters: params);
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future createAttendances(File image_in, String store_id, int shfit, double lat_in, double lon_in, range_in) async {
    try {
      String fileName = basename(image_in.path);
      var userData = await Local.getUserData();
      FormData formData = FormData.fromMap({
        'pegawai_id': userData['user_id'],
        "image_in": await MultipartFile.fromFile(image_in.path, filename: fileName),
        'store_id': store_id,
        'shift': shfit,
        'lat_in': lat_in,
        'lon_in': lon_in,
        'range_in': range_in,
      });
      var response = await dio.post("/pegawai/attendances/create.php", data: formData);
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future updateAttendances(File image_in, double lat_in, double lon_in, range_in) async {
    try {
      String fileName = basename(image_in.path);
      var userData = await Local.getUserData();
      FormData formData = FormData.fromMap({
        'pegawai_id': userData['user_id'],
        "image_out": await MultipartFile.fromFile(image_in.path, filename: fileName),
        'lat_out': lat_in,
        'lon_out': lon_in,
        'range_out': range_in,
      });
      var response = await dio.post("/pegawai/attendances/update.php", data: formData);
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getOneStore(storeId) async {
    try {
      var response = await dio.get("/pegawai/stores/get_one.php/$storeId");
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getLaporanPetugas(DateTimeRange range) async {
    try {
      var userData = await Local.getUserData();
      if (userData['user_role'] == 'admin') {
        var resp = await dio.get('/admin/laporan/petugas_absensi.php', queryParameters: {
          'admin_id': userData['user_id'],
          'start_date': range.start.toString().substring(0, 10),
          'end_date': range.end.toString().substring(0, 10),
        });
        return resp.data;
      } else {
        var resp = await dio.get('/pegawai/attendances/get.php', queryParameters: {
          'pegawai_id': userData['user_id'],
          'start_date': range.start.toString().substring(0, 10),
          'end_date': range.end.toString().substring(0, 10),
        });
        return resp.data;
      }
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getPetugasLaporanPenjualan(DateTimeRange range) async {
    try {
      var userData = await Local.getUserData();
      var resp = await dio.get('/pegawai/laporan/penjualan.php', queryParameters: {
        'pegawai_id': userData['user_id'],
        'start_date': range.start.toString().substring(0, 10),
        'end_date': range.end.toString().substring(0, 10),
      });
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getTabungan() async {
    try {
      var userData = await Local.getUserData();
      var resp = await dio.get('/pegawai/laporan/tabungan.php', queryParameters: {
        'pegawai_id': userData['user_id'],
      });
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  Future getListSetoran(DateTimeRange range) async {
    try {
      var userData = await Local.getUserData();
      var resp = await dio.get('/pegawai/laporan/setoran.php', queryParameters: {
        'pegawai_id': userData['user_id'],
        'start_date': range.start.toString().substring(0, 10),
        'end_date': range.end.toString().substring(0, 10),
      });
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getPetugasLaporanTambahan() async {
    try {
      var userData = await Local.getUserData();
      var resp = await dio.get('/pegawai/laporan/laporan_tambahan_get.php', queryParameters: {
        'pegawai_id': userData['user_id'],
      });
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getLaporanKategori() async {
    try {
      var resp = await dio.get('/pegawai/laporan/laporan_kategori_get.php');
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future createLaporanTambahan(String imagePath, double lat, double lon, range, reportCategoryId, desc) async {
    try {
      String fileName = basename(imagePath);
      var userData = await Local.getUserData();
      FormData formData = FormData.fromMap({
        'pegawai_id': userData['user_id'],
        "image": await MultipartFile.fromFile(imagePath, filename: fileName),
        'lat': lat,
        'lon': lon,
        'range': range,
        'report_category_id': reportCategoryId,
        'description': desc
      });
      var response = await dio.post("/pegawai/laporan/laporan_tambahan_create.php", data: formData);
      return response.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future updateName(name) async {
    try {
      var userData = await Local.getUserData();
      if (userData['user_role'] == 'admin') {
        FormData formData = FormData.fromMap({
          'admin_id': userData['user_id'],
          "name": name,
        });
        var response = await dio.post("/admin/auth/update_name.php", data: formData);
        return response.data;
      } else {
        FormData formData = FormData.fromMap({
          'pegawai_id': userData['user_id'],
          "name": name,
        });
        var response = await dio.post("/pegawai/auth/update_name.php", data: formData);
        return response.data;
      }
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future updatePassword(passwordlama, passwordbaru) async {
    try {
      var userData = await Local.getUserData();
      if (userData['user_role'] == 'admin') {
        FormData formData = FormData.fromMap({
          'admin_id': userData['user_id'],
          "password_lama": passwordlama,
          "password_baru": passwordbaru,
        });
        var response = await dio.post("/admin/auth/update_password.php", data: formData);
        return response.data;
      } else {
        FormData formData = FormData.fromMap({
          'pegawai_id': userData['user_id'],
          "password_lama": passwordlama,
          "password_baru": passwordbaru,
        });
        var response = await dio.post("/pegawai/auth/update_password.php", data: formData);
        return response.data;
      }
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }

  static Future getAdminLaporanTambahan(DateTimeRange date) async {
    String formattedBeginDate = DateFormat('yyyy-MM-dd').format(date.start);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(date.end);
    try {
      var userData = await Local.getUserData();
      var resp = await dio.get('/admin/laporan/laporan_tambahan.php', queryParameters: {
        'admin_id': userData['user_id'],
        'start_date': formattedBeginDate,
        'end_date': formattedEndDate,
      });
      return resp.data;
    } catch (e) {
      return {'success': false, 'errors': e.toString()};
    }
  }
}
