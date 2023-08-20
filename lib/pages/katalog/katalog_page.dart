import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/katalog/pembayaran_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/petugas_drawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/custom_icons.dart';

// ignore: must_be_immutable
class KatalogPage extends StatelessWidget {
  KatalogPage({super.key, required this.role});
  final String role;
  TextEditingController search = TextEditingController(text: "");
  String? selectedStore;
  bool firstOpen = true;
  List dataItems = [];

  final ValueNotifier<int> updatePrice = ValueNotifier(0);
  final ValueNotifier<bool> refreshItem = ValueNotifier(false);

  Future refresh() async {
    dataItems = [];
    updatePrice.value = 0;
    refreshItem.value = !refreshItem.value;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog')),
      drawer: role == 'admin' ? DrawerAdmin(size: size, active: 2) : DrawerPetugas(size: size, active: 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: checkoutButton(size, context),

      body: role == 'user'
          ? RefreshIndicator(
              onRefresh: () async {
                refresh();
              },
              child: FutureBuilder(
                future: Services.getUserInformation(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView(
                      children: [
                        LottieBuilder.asset('assets/lotties/loading.json'),
                      ],
                    );
                  } else if (!snapshot.data!['success']) {
                    return ListView(
                      children: [Image.asset('assets/images/error.png'), Text(snapshot.data!['errors'])],
                    );
                  } else if (snapshot.data!['data'][0]['status_attendance'] == '0') {
                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const SizedBox(height: 100),
                        Image.asset('assets/images/absen.png'),
                        const Text('Anda Belum Absen', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: () {}, child: const Text('Absen')),
                      ],
                    );
                  } else if (snapshot.data['data'][0]['status_attendance'] == '2') {
                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const SizedBox(height: 100),
                        Image.asset('assets/images/absen.png'),
                        const Text('Anda Sudah Absen Keluar', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: () {}, child: const Text('Laporan Harian')),
                      ],
                    );
                  } else {
                    var data = snapshot.data['data'][0];
                    selectedStore = data['store_active_id'];
                    return ListView(
                      children: [
                        searchBar(context),
                        ValueListenableBuilder(
                            valueListenable: refreshItem,
                            builder: (context, val, _) {
                              return FutureBuilder(
                                future: Services().getKatalogItem(selectedStore),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Column(
                                      children: [
                                        LottieBuilder.asset('assets/lotties/loading.json'),
                                      ],
                                    );
                                  } else if (!snapshot.data['success']) {
                                    return Column(
                                      children: [
                                        Image.asset('assets/images/error.png'),
                                        Text(data['errors']),
                                      ],
                                    );
                                  } else {
                                    if (dataItems.length != snapshot.data['data'].length) {
                                      snapshot.data['data'].forEach((element) {
                                        element['count'] = 0;
                                      });
                                      print("perubahan data");
                                      dataItems = snapshot.data['data'];
                                    }
                                    return buildKatalogItem(dataItems);
                                  }
                                },
                              );
                            }),
                        const SizedBox(height: 100),
                      ],
                    );
                  }
                },
              ),
            )
          : SizedBox(),
      // RefreshIndicator(
      //         onRefresh: () async {
      //           ref.invalidate(futureGetKatalogItem);
      //           ref.invalidate(countItemProvider);
      //           ref.invalidate(priceProvider);
      //           ref.invalidate(futureGetOutletsProvider);
      //         },
      //         child: ListView(
      //           children: [
      //             searchBar(context),
      //             storeDropDown(ref),
      //             if (selectedStore == null)
      //               SizedBox()
      //             else
      //               ref.watch(futureGetKatalogItem(selectedStore!)).when(
      //                     skipLoadingOnRefresh: false,
      //                     data: (data) {
      //                       return buildKatalogItem(data, ref);
      //                     },
      //                     error: (error, stackTrace) => const Center(child: Text("Gagal Ambil Data")),
      //                     loading: () => Center(
      //                       child: LottieBuilder.asset('assets/lotties/loading.json'),
      //                     ),
      //                   ),
      //             const SizedBox(height: 100),
      //           ],
      //         ),
      //       )
    );
  }

  Widget buildKatalogItem(data) {
    List showItems;

    if (search.text.isNotEmpty) {
      showItems = data.where((element) => element['name'].toString().toLowerCase().contains(search.text.toLowerCase())).toList();
    } else {
      showItems = data;
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: showItems.length,
      itemBuilder: (context, index) => Card(
          color: const Color(0xffF6F6F6),
          surfaceTintColor: const Color(0xffF6F6F6),
          elevation: 0,
          child: StatefulBuilder(builder: (context, set) {
            return ListTile(
              leading: CustomIcon(id: int.parse(showItems[index]['icon'])),
              title: Text(showItems[index]['name'] ?? 'NULL', style: TextStyles.h3),
              subtitle: Text(numberFormat.format(int.parse(showItems[index]['price'])), style: TextStyles.p),
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
                            set(() {
                              showItems[index]['count'] -= 1;
                              updatePrice.value -= int.parse(showItems[index]['price']);
                            });
                          })
                      : const SizedBox(),
                  showItems[index]['count'] != 0 ? Text(showItems[index]['count'].toString()) : const SizedBox(),
                  IconButton(
                      icon: const Icon(Icons.add_circle),
                      color: Colors.green,
                      splashColor: Colors.blue,
                      onPressed: () {
                        set(() {
                          showItems[index]['count'] += 1;
                          updatePrice.value += int.parse(showItems[index]['price']);
                        });
                      }),
                  // futureGetItemsProvider.
                ],
              ),
              onTap: () {
                set(() {
                  showItems[index]['count'] += 1;
                  updatePrice.value += int.parse(showItems[index]['price']);
                  // updatePrice.value = 10;
                });
              },
            );
          })),
    );
  }

  SizedBox searchBar(BuildContext context) {
    return SizedBox(
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
    );
  }

  Widget storeDropDown() {
    return FutureBuilder(
      future: Services().getOutlets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: Colors.white.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(),
              ));
        } else {
          List data = snapshot.data['data'];
          if (firstOpen) {
            selectedStore = data.first['id'];
            firstOpen = false;
          }
          return DropdownButtonFormField(
            value: selectedStore,
            items: data.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']))).toList(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            borderRadius: BorderRadius.circular(10),
            onChanged: (value) {
              search.text = "";
              selectedStore = value as String;
            },
          );
        }
      },
    );
  }

  Widget checkoutButton(Size size, BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: updatePrice,
        builder: (context, val, child) {
          print(val);
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: val != 0 ? 1 : 0,
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
                        numberFormat.format(val).toString(),
                        style: TextStyles.h2Light,
                      )),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                      backgroundColor: const Color(0xff449DD1),
                      foregroundColor: Colors.white,
                      onPressed: val == 0
                          ? null
                          : () async {
                              await Future.delayed(const Duration(milliseconds: 200));
                              if (selectedStore != null) {
                                List items = dataItems.where((element) => element['count'] != 0).toList();
                                push(
                                    context,
                                    PembayaranPage(
                                      storeId: selectedStore!,
                                      items: items,
                                      price: updatePrice.value,
                                    ));
                              }
                            },
                      child: const Icon(Icons.arrow_forward)),
                ],
              ),
            ),
          );
        });
  }
}
