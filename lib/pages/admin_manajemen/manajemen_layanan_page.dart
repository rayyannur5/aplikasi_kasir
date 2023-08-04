import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/providers.dart';
import '../../utils/formatter.dart';
import '../../utils/textstyles.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/custom_icons.dart';

// ignore: must_be_immutable
class ManajemenLayananPage extends ConsumerWidget {
  ManajemenLayananPage({super.key});
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Layanan')),
      drawer: DrawerAdmin(size: size, active: 3),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff449DD1),
          foregroundColor: Colors.white,
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            var name = TextEditingController();
            var harga = TextEditingController();
            int icon = 0;

            // ignore: use_build_context_synchronously
            modalItemManajemen(ref, context, icon, name, harga, null, null);
          },
          child: const Icon(Icons.add)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureGetItemsProvider);
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
                    child: TextField(controller: search, textInputAction: TextInputAction.search, decoration: const InputDecoration(hintText: 'Cari Layanan/Barang', prefixIcon: Icon(Icons.search))),
                  ),
                ],
              ),
            ),
            ref.watch(futureGetItemsProvider(1)).when(
                  skipLoadingOnRefresh: false,
                  data: (items) {
                    List showItems;
                    if (search.text.isNotEmpty) {
                      showItems = items.where((element) => element['nama'].toString().toLowerCase().contains(search.text.toLowerCase())).toList();
                    } else {
                      showItems = items;
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      itemCount: showItems.length,
                      itemBuilder: (context, index) => Card(
                          color: const Color(0xffF6F6F6),
                          surfaceTintColor: const Color(0xffF6F6F6),
                          elevation: 5,
                          child: ListTile(
                            leading: CustomIcon(id: int.parse(showItems[index]['icon'])),
                            title: Text(showItems[index]['nama'] ?? 'NULL', style: TextStyles.h3),
                            subtitle: Text("[${showItems[index]['outlet_nama']}] ${numberFormat.format(int.parse(showItems[index]['harga']))}", style: TextStyles.p),
                            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            trailing: IconButton(icon: const Icon(Icons.border_color), onPressed: () {}),
                            onTap: () {
                              var name = TextEditingController(text: showItems[index]['nama']);
                              var harga = TextEditingController(text: showItems[index]['harga']);
                              var icon = int.parse(showItems[index]['icon']);
                              var kategori = int.parse(showItems[index]['kategori']);
                              var outlet = int.parse(showItems[index]['outlet_id']);
                              modalItemManajemen(ref, context, icon, name, harga, kategori, outlet);
                            },
                          )),
                    );
                  },
                  error: (error, stackTrace) => const Center(child: Text("Gagal Ambil Data")),
                  loading: () => Center(
                    child: LottieBuilder.asset('assets/lotties/loading.json'),
                  ),
                ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalItemManajemen(WidgetRef ref, BuildContext context, int icon, TextEditingController name, TextEditingController harga, int? kategori, int? outlet) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, StateSetter setState) {
        return Consumer(builder: (context, ref, child) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text('Tambah Layanan', textAlign: TextAlign.center, style: TextStyles.h2),
                const SizedBox(height: 20),
                Text('Pilih Icon', style: TextStyles.h3),
                const SizedBox(height: 20),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 15, mainAxisSpacing: 15),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 12,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => setState(() {
                      icon = index;
                    }),
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: icon == index ? Colors.blue.shade900 : Colors.transparent, borderRadius: BorderRadius.circular(5)),
                        child: CustomIcon(id: index)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(controller: name, keyboardType: TextInputType.name, decoration: const InputDecoration(hintText: 'Nama Layanan')),
                const SizedBox(height: 20),
                TextField(controller: harga, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Harga')),
                const SizedBox(height: 20),
                ref.watch(futureGetOutletsProvider(1)).when(
                      data: (data) => DropdownButtonFormField(
                        hint: const Text('Pilih Outlet'),
                        items: data
                            .map((e) => DropdownMenuItem(
                                  value: int.parse(e['id']),
                                  child: Text(e['nama']),
                                ))
                            .toList(),
                        value: outlet,
                        onChanged: (value) => setState(() {
                          outlet = value;
                        }),
                      ),
                      error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
                      loading: () => Shimmer.fromColors(
                          baseColor: Colors.transparent,
                          highlightColor: Colors.white.withOpacity(0.5),
                          child: Container(margin: const EdgeInsets.symmetric(horizontal: 20), height: 55, color: Colors.black)),
                    ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (name.text.isEmpty) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(content: const Text('Nama tidak boleh kosong'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                        return;
                      } else if (harga.text.isEmpty) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(content: const Text('Harga tidak boleh kosong'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                        return;
                      }
                      showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
                      await Services.addItems(icon, name.text, harga.text, kategori);
                      pushAndRemoveUntil(context, ManajemenLayananPage());
                    },
                    child: const Text('Simpan')),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      }),
    );
  }
}
