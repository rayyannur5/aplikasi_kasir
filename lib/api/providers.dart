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
var futureDeviceCountTransactionsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getCountDeviceTransactions());
var futureCashierCountTransactionsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getCountCashierTransactions());
var futureOpenedOutletsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getOpenedOutlets());
var futureActivedEmployeesProvider = FutureProvider((ref) => ref.watch(servicesProvider).getActivedEmployees());
var futureOmsetComparisonProvider = FutureProvider((ref) => ref.watch(servicesProvider).getOmsetComparison());
var futureChartTodayTransactionsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getChartTodayTransactions());

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
var futureReportAIDeviceProvider = FutureProvider.autoDispose.family((ref, Map parameterReportAI) => ref.watch(servicesProvider).getAIDevice(parameterReportAI));
var parameterReportAIProvider = StateProvider(
  (ref) => {
    'date': DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    'outlet_id': '1',
  },
);

// Laporan Transaksi Admin
var futureYearGetTransactionProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getYearReportTransaction());
var futureMonthGetTransactionProvider = FutureProvider.autoDispose.family((ref, String year) => ref.watch(servicesProvider).getMonthReportTransaction(year));
var futureDayGetTransactionProvider = FutureProvider.autoDispose.family((ref, String month) => ref.watch(servicesProvider).getDayReportTransaction(month));
var futureHourGetTransactionProvider = FutureProvider.autoDispose.family((ref, String day) => ref.watch(servicesProvider).getHourReportTransaction(day));

// Laporan Perbandingan
var futurePerbandinganReportProvider = FutureProvider.autoDispose.family((ref, Map parameter) => ref.watch(servicesProvider).getPerbandinganReport(parameter));
var parameterPerbandinganReportProvider = StateProvider(
  (ref) => {
    'date': DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    'outlet_id': '1',
  },
);

// Petugas Laporan Penjualan
var parameterPetugasLaporanPenjualan = StateProvider((ref) => DateTimeRange(start: DateTime.now(), end: DateTime.now()));
var futurePetugasLaporanPenjualan = FutureProvider.autoDispose.family((ref, DateTimeRange range) => ref.watch(servicesProvider).getPetugasLaporanPenjualan(range));
