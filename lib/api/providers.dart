import 'package:aplikasi_kasir/api/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var servicesProvider = Provider<Services>(
  (ref) => Services(),
);

var countItemProvider = StateProvider.autoDispose(
  (ref) => [],
);

var priceProvider = StateProvider.autoDispose((ref) => 0);
var amountProvider = StateProvider.autoDispose((ref) => 0);

// DASHBOARD

// MANAJEMEN LAYANAN
var futureGetItemsProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getItems());

var futureGetEmployeesProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getEmployees());
var futureGetKodeReferralProvider = FutureProvider((ref) => ref.watch(servicesProvider).getKodeReferral());
var futureGetPricesProvider = FutureProvider.family.autoDispose((ref, String storeId) => ref.watch(servicesProvider).getPrices(storeId));

var futureGetOutletsProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getOutlets());

var futureGetShiftProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getShift());

// MANAJEMEN CITY
var futureGetCitiesProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getCities());

// Ringkasan AI Device
// var futureReportAIDeviceProvider = FutureProvider.autoDispose.family((ref, Map parameterReportAI) => ref.watch(servicesProvider).getAIDevice(parameterReportAI));
var parameterReportAIProvider = StateProvider(
  (ref) => {
    'date': DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    'outlet_id': '1',
  },
);

// Laporan Transaksi Admin

// Laporan Perbandingan

// Petugas Laporan Penjualan
var parameterPetugasLaporanPenjualan = StateProvider((ref) => DateTimeRange(start: DateTime.now(), end: DateTime.now()));
var futurePetugasLaporanPenjualan = FutureProvider.autoDispose.family((ref, DateTimeRange range) => ref.watch(servicesProvider).getPetugasLaporanPenjualan(range));

// Katalog
