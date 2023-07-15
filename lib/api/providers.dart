import 'package:aplikasi_kasir/api/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var servicesProvider = Provider<Services>(
  (ref) => Services(),
);

var countItemProvider = StateProvider(
  (ref) => [],
);

var selectedKategoriProvider = StateProvider((ref) => 0);

var priceProvider = StateProvider((ref) => 0);
var amountProvider = StateProvider.autoDispose((ref) => 0);

var futureDeviceCountTransactionsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getCountDeviceTransactions());
var futureCashierCountTransactionsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getCountCashierTransactions());
var futureOpenedOutletsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getOpenedOutlets());
var futureActivedEmployeesProvider = FutureProvider((ref) => ref.watch(servicesProvider).getActivedEmployees());
var futureOmsetComparisonProvider = FutureProvider((ref) => ref.watch(servicesProvider).getOmsetComparison());
var futureChartTodayTransactionsProvider = FutureProvider((ref) => ref.watch(servicesProvider).getChartTodayTransactions());
var futureGetItemsProvider = FutureProvider.family((ref, int outlet_id) => ref.watch(servicesProvider).getItems(outlet_id));
var futureGetKategoriesProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getKategories());

var futureGetEmployeesProvider = FutureProvider.autoDispose.family((ref, String keyword) => ref.watch(servicesProvider).getEmployees(keyword));
var futureGetKodeReferralProvider = FutureProvider((ref) => ref.watch(servicesProvider).getKodeReferral());

var futureGetOutletsProvider = FutureProvider.autoDispose.family((ref, String keyword) => ref.watch(servicesProvider).getOutlets(keyword));

var futureGetShiftProvider = FutureProvider.autoDispose((ref) => ref.watch(servicesProvider).getShift());
