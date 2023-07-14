import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/katalog/pembayaran_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/custom_icons.dart';

// ignore: must_be_immutable
class KatalogPage extends ConsumerWidget {
  KatalogPage({super.key});
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List countItem = ref.watch(countItemProvider);
    var size = MediaQuery.of(context).size;
    int price = ref.watch(priceProvider);
    int selectedKategori = ref.watch(selectedKategoriProvider);
    // var selectedKategori = ref.watch(selectedKategoriProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog')),
      drawer: DrawerAdmin(size: size, active: 2),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: price != 0 ? 1 : 0,
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: size.width - (size.width / 3),
                child: Card(
                  elevation: 10,
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                      title: Text(
                    numberFormat.format(price).toString(),
                    style: TextStyles.h2Light,
                  )),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                  backgroundColor: const Color(0xff449DD1),
                  foregroundColor: Colors.white,
                  onPressed: price == 0 ? null : () => Future.delayed(Duration(milliseconds: 200), () => push(context, PembayaranPage())),
                  child: const Icon(Icons.arrow_forward)),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureGetItemsProvider);
          ref.invalidate(countItemProvider);
          ref.invalidate(priceProvider);
          ref.invalidate(selectedKategoriProvider);
          ref.invalidate(futureGetKategoriesProvider);
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
            ref.watch(futureGetKategoriesProvider).when(
                  skipLoadingOnRefresh: false,
                  data: (kategories) {
                    if (kategories.where((element) => element['id'] == '0').toList().isEmpty) {
                      kategories.add({
                        'id': '0',
                        'nama': 'Semua Layanan',
                      });
                    }
                    return DropdownButtonFormField(
                      value: kategories.last,
                      items: kategories.map((e) => DropdownMenuItem(value: e, child: Text(e['nama']))).toList(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (value) {
                        search.text = "";
                        ref.read(selectedKategoriProvider.notifier).state = int.parse(value!['id']);
                      },
                    );
                  },
                  error: (error, stackTrace) => Container(height: 55, color: Colors.grey, child: const Center(child: Text('Gagal Ambil Data'))),
                  loading: () => Shimmer.fromColors(
                      baseColor: Colors.transparent,
                      highlightColor: Colors.white.withOpacity(0.5),
                      child: Container(margin: const EdgeInsets.symmetric(horizontal: 20), height: 55, color: Colors.black)),
                ),
            ref.watch(futureGetItemsProvider).when(
                  skipLoadingOnRefresh: false,
                  data: (items) {
                    if (countItem.length != items.length) {
                      for (int i = 0; i < items.length; i++) {
                        ref.read(countItemProvider).add({
                          'id': items[i]['id'],
                          'count': 0,
                        });
                        items[i]['count'] = 0;
                      }
                    }

                    List showItems;
                    if (selectedKategori == 0) {
                      if (search.text.isNotEmpty) {
                        showItems = items.where((element) => element['nama'].toString().toLowerCase().contains(search.text.toLowerCase())).toList();
                      } else {
                        showItems = items;
                      }
                    } else {
                      showItems = items.where((element) => element['kategori'] == selectedKategori.toString()).toList();
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
                            subtitle: Text(numberFormat.format(int.parse(showItems[index]['harga'])), style: TextStyles.p),
                            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                showItems[index]['count'] != 0
                                    ? IconButton(
                                        icon: const Icon(Icons.remove_circle),
                                        color: Colors.red,
                                        splashColor: Colors.red,
                                        onPressed: () {
                                          showItems[index]['count'] -= 1;
                                          ref.read(priceProvider.notifier).state -= int.parse(showItems[index]['harga']);
                                        })
                                    : const SizedBox(),
                                showItems[index]['count'] != 0 ? Text(showItems[index]['count'].toString()) : const SizedBox(),
                                IconButton(
                                    icon: const Icon(Icons.add_circle),
                                    color: Colors.green,
                                    splashColor: Colors.blue,
                                    onPressed: () {
                                      showItems[index]['count'] += 1;
                                      ref.read(priceProvider.notifier).state += int.parse(showItems[index]['harga']);
                                    }),
                                // futureGetItemsProvider.
                              ],
                            ),
                            onTap: () {
                              showItems[index]['count'] += 1;
                              ref.read(priceProvider.notifier).state += int.parse(showItems[index]['harga']);
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
}
