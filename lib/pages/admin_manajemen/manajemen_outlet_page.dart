import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_scan_qrcode_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/pick_location_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../utils/textstyles.dart';

class ManajemenOutletPage extends ConsumerWidget {
  ManajemenOutletPage({super.key});
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Outlet')),
      drawer: DrawerAdmin(size: size, active: 6),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => materialPush(context, ScanQRPage())),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureGetOutletsProvider);
        },
        child: ListView(
          children: [
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    alignment: Alignment.center,
                    child: TextField(
                        controller: search,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => ref.invalidate(futureGetOutletsProvider),
                        decoration: const InputDecoration(hintText: 'Cari Cabang/Outlet', prefixIcon: Icon(Icons.search))),
                  ),
                ],
              ),
            ),
            ref.watch(futureGetOutletsProvider(1)).when(
                  skipLoadingOnRefresh: false,
                  data: (data) => ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) => Card(
                          color: const Color(0xffF6F6F6),
                          child: ListTile(
                            title: Text(data[index]['nama'], style: TextStyles.h2),
                            subtitle: Text(data[index]['addr']),
                            trailing: const Icon(Icons.border_color),
                            onTap: () {
                              var editOutlet = TextEditingController(text: data[index]['nama']);
                              var lokasi = TextEditingController(text: "${data[index]['lat']}, ${data[index]['lat']}");
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(builder: (context, setState) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Ubah Outlet'),
                                          content: Column(
                                            children: [
                                              CupertinoTextField(controller: editOutlet, placeholder: 'Ubah Outlet', decoration: BoxDecoration(color: Colors.white.withOpacity(0.4))),
                                              const SizedBox(height: 10),
                                              CupertinoTextField(controller: lokasi, placeholder: 'Lokasi', enabled: false, decoration: BoxDecoration(color: Colors.white.withOpacity(0.4))),
                                              const SizedBox(height: 10),
                                              CupertinoButton.filled(
                                                  child: const Text('Pilih Lokasi'),
                                                  onPressed: () async {
                                                    GeoPoint temp = await Navigator.push(context, MaterialPageRoute(builder: (context) => const PickLoactionPage()));
                                                    setState(() {
                                                      lokasi.text = "${temp.latitude}, ${temp.longitude}";
                                                    });
                                                  }),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  pop(context);
                                                },
                                                child: const Text('Simpan')),
                                            TextButton(
                                                onPressed: () {
                                                  pop(context);
                                                },
                                                child: const Text('Hapus')),
                                            TextButton(onPressed: () => pop(context), child: const Text('Batal')),
                                          ],
                                        );
                                      }));
                            },
                          ))),
                  error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
                  loading: () => Center(child: LottieBuilder.asset('assets/lotties/loading.json')),
                ),
          ],
        ),
      ),
    );
  }
}
