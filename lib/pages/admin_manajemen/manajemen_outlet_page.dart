import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_scan_qrcode_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            ref.watch(futureGetOutletsProvider(search.text)).when(
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
                            trailing: const Icon(Icons.border_color),
                            onTap: () {
                              var editOutlet = TextEditingController();
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        title: const Text('Tambah Kategori'),
                                        content: CupertinoTextField(controller: editOutlet, placeholder: 'Nama Kategori', decoration: BoxDecoration(color: Colors.white.withOpacity(0.4))),
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
                                      ));
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
