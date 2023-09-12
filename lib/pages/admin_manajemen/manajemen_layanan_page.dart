import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_layanan_harga_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../api/providers.dart';
import '../../utils/textstyles.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/custom_icons.dart';

class ManajemenLayananPage extends ConsumerWidget {
  TextEditingController search = TextEditingController();

  ManajemenLayananPage({super.key});
  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Layanan'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            dividerColor: Theme.of(context).primaryColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Produk'),
              Tab(text: 'Harga'),
            ],
          ),
        ),
        drawer: DrawerAdmin(size: size, active: 3),
        body: TabBarView(
          children: [produkPage(ref, context), pricePage(ref, context)],
        ),
      ),
    );
  }

  RefreshIndicator pricePage(WidgetRef ref, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(futureGetOutletsProvider);
      },
      child: FutureBuilder(
        future: Services().getOutlets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
          } else if (!snapshot.data['success']) {
            Future.delayed(const Duration(milliseconds: 200),
                () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snapshot.data['errors']))));
            return ListView(children: [const SizedBox(height: 100), Image.asset('assets/images/error.png')]);
          } else {
            var data = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: data['data'].length,
              itemBuilder: (context, index) => Card(
                color: const Color(0xffF6F6F6),
                surfaceTintColor: const Color(0xffF6F6F6),
                elevation: 0,
                child: ListTile(
                  title: Text(data['data'][index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(data['data'][index]['addr']),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    push(context, ManajemenLayananHargaPage(outletId: data['data'][index]['id'], outletName: data['data'][index]['name']));
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Scaffold produkPage(WidgetRef ref, BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff449DD1),
          foregroundColor: Colors.white,
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            var name = TextEditingController();
            int icon = 0;
            // ignore: use_build_context_synchronously
            modalItemManajemen(ref, context, null, icon, name, null, 'Tambah Layanan');
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
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    alignment: Alignment.center,
                    child: TextField(
                        controller: search,
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(hintText: 'Cari Layanan/Barang', prefixIcon: Icon(Icons.search))),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: Services().getItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
                } else if (!snapshot.data!['success']) {
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 50),
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data!['errors']),
                    ],
                  );
                } else {
                  var items = snapshot.data;

                  List showItems;
                  if (search.text.isNotEmpty) {
                    showItems =
                        items!['data'].where((element) => element['name'].toString().toLowerCase().contains(search.text.toLowerCase())).toList();
                  } else {
                    showItems = items!['data'];
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
                        child: ListTile(
                          leading: CustomIcon(id: int.parse(showItems[index]['icon'])),
                          title: Text(showItems[index]['name'] ?? 'NULL', style: TextStyles.h3),
                          contentPadding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
                          trailing: const Icon(Icons.border_color),
                          onTap: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            var name = TextEditingController(text: showItems[index]['name']);
                            var icon = int.parse(showItems[index]['icon']);
                            modalItemManajemen(ref, context, showItems[index]['id'], icon, name, showItems[index]['device_product'], 'Ubah Layanan');
                          },
                        )),
                  );
                }
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Future<dynamic> modalItemManajemen(WidgetRef ref, BuildContext context, id, int icon, TextEditingController name, deviceProduct, title) {
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
                Text(title, textAlign: TextAlign.center, style: TextStyles.h2),
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
                        decoration:
                            BoxDecoration(color: icon == index ? Colors.blue.shade900 : Colors.transparent, borderRadius: BorderRadius.circular(5)),
                        child: CustomIcon(id: index)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(controller: name, keyboardType: TextInputType.name, decoration: const InputDecoration(hintText: 'Nama Layanan')),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (name.text.isEmpty) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                content: const Text('Nama tidak boleh kosong'),
                                actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                        return;
                      }
                      showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
                      if (title == 'Ubah Layanan') {
                        Map res = await Services.editItems(id, icon, name.text);
                        if (res['success']) {
                          ref.invalidate(futureGetItemsProvider);
                          pushAndRemoveUntil(context, ManajemenLayananPage());
                        } else {
                          pop(context);
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                  content: Text(res['errors']), actions: [TextButton(onPressed: () => pop(context), child: const Text('OK'))]));
                        }
                      } else {
                        Map res = await Services.addItems(icon, name.text);
                        if (res['success']) {
                          ref.invalidate(futureGetItemsProvider);
                          pushAndRemoveUntil(context, ManajemenLayananPage());
                        } else {
                          pop(context);
                          showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                  content: Text(res['errors']), actions: [TextButton(onPressed: () => pop(context), child: const Text('OK'))]));
                        }
                      }
                    },
                    child: const Text('Simpan')),
                const SizedBox(height: 20),
                deviceProduct == "0" && deviceProduct != null
                    ? ElevatedButton(
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              content: const Text('Yakin Untuk Menghapus Data ?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
                                      var res = await Services.deleteItems(id);
                                      if (res['success']) {
                                        ref.invalidate(futureGetItemsProvider);
                                        pushAndRemoveUntil(context, ManajemenLayananPage());
                                      } else {
                                        pop(context);
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (context) => CupertinoAlertDialog(
                                                content: Text(res['errors']),
                                                actions: [TextButton(onPressed: () => pop(context), child: const Text('OK'))]));
                                      }
                                    },
                                    child: const Text('Hapus')),
                                TextButton(onPressed: () => pop(context), child: const Text('Batal'))
                              ],
                            ),
                          );
                        },
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                        child: const Text('Hapus'))
                    : const SizedBox(),
                const SizedBox(height: 20),
              ],
            ),
          );
        });
      }),
    );
  }
}
