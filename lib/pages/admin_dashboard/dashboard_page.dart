import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/card_shimmer_loading.dart';
import '../../widgets/custom_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: DrawerAdmin(size: size, active: 1),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  Container(
                    height: 75,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 200,
                    decoration: BoxDecoration(
                        color: const Color(0xff3943B7),
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(image: AssetImage('assets/images/card-bg.png'), fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter)),
                    child: FutureBuilder(
                      future: Services.getOmsetComparison(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Shimmer.fromColors(
                              baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Container(height: 150, width: double.infinity, color: Colors.black));
                        } else if (!snapshot.data!['success']) {
                          return Column(
                            children: [
                              Image.asset('assets/images/error.png', scale: 2),
                              Text('Gagal Ambil Data, Refresh Kembali', style: TextStyle(color: Colors.white)),
                            ],
                          );
                        } else {
                          print(snapshot.data);
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Text('Omset AI Device', style: TextStyle(fontSize: 16, color: Colors.white)),
                                Text(numberFormat.format(snapshot.data!['data']['device']), style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                                const Text('Omset Kasir', style: TextStyle(fontSize: 16, color: Colors.white)),
                                Text(numberFormat.format(snapshot.data!['data']['kasir']), style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold))
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                Card(
                    elevation: 8,
                    color: const Color(0xffDFA100),
                    child: FutureBuilder(
                      future: Services.getCountCashierTransactions(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CardShimmerLoading();
                        } else if (!snapshot.data['success']) {
                          return Column(
                            children: [
                              Image.asset('assets/images/error.png', scale: 2),
                              Text('Gagal Ambil Data, Refresh Kembali', style: TextStyle(color: Colors.white)),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Transaksi Kasir',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(text: snapshot.data!['data'].toString(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                                    const TextSpan(text: ' Kali', style: TextStyle(fontSize: 12)),
                                  ]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )),
                Card(
                    elevation: 8,
                    color: const Color(0xff6CC94B),
                    child: FutureBuilder(
                      future: Services.getCountDeviceTransactions(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CardShimmerLoading();
                        } else if (!snapshot.data['success']) {
                          return Column(
                            children: [
                              Image.asset('assets/images/error.png', scale: 2),
                              Text('Gagal Ambil Data, Refresh Kembali', style: TextStyle(color: Colors.white)),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Transaksi Device',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(text: snapshot.data!['data'].toString(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                                    const TextSpan(text: ' Kali', style: TextStyle(fontSize: 12)),
                                  ]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )),
                Card(
                    elevation: 8,
                    color: const Color(0xff449DD1),
                    child: FutureBuilder(
                      future: Services.getOpenedOutlets(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CardShimmerLoading();
                        } else if (!snapshot.data['success']) {
                          return Column(
                            children: [
                              Image.asset('assets/images/error.png', scale: 2),
                              Text('Gagal Ambil Data, Refresh Kembali', style: TextStyle(color: Colors.white)),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Banyak Outlet Terbuka',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(text: snapshot.data!['data'].toString(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                                    const TextSpan(text: ' Outlet', style: TextStyle(fontSize: 12)),
                                  ]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )),
                Card(
                    elevation: 8,
                    color: const Color(0xffD14C44),
                    child: FutureBuilder(
                      future: Services.getActivedEmployees(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CardShimmerLoading();
                        } else if (!snapshot.data['success']) {
                          return Column(
                            children: [
                              Image.asset('assets/images/error.png', scale: 2),
                              Text('Gagal Ambil Data, Refresh Kembali', style: TextStyle(color: Colors.white)),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Banyak Petugas Aktif',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(text: snapshot.data!['data'].toString(), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                                    const TextSpan(text: ' Petugas', style: TextStyle(fontSize: 12)),
                                  ]),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transaksi Hari Ini', style: TextStyles.h3),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: Services.getChartTodayTransactions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(height: 200, child: Center(child: LottieBuilder.asset('assets/lotties/loading.json')));
                      } else if (!snapshot.data['success']) {
                        return Column(
                          children: [
                            Image.asset('assets/images/error.png', scale: 2),
                            Text('Gagal Ambil Data, Refresh Kembali', style: TextStyle(color: Colors.white)),
                          ],
                        );
                      } else {
                        print(snapshot.data['data']);
                        return CustomChart(data: snapshot.data['data']);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
