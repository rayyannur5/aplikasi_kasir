import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class KategoriLayananPage extends ConsumerStatefulWidget {
  const KategoriLayananPage({super.key});

  @override
  ConsumerState<KategoriLayananPage> createState() => _KategoriLayananPageState();
}

class _KategoriLayananPageState extends ConsumerState<KategoriLayananPage> {
  final TextEditingController addKategori = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(futureGetItemsProvider);
        ref.invalidate(futureGetKategoriesProvider);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Kategori Layanan', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, foregroundColor: Colors.black),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                          title: const Text('Tambah Kategori'),
                          content: CupertinoTextField(controller: addKategori, placeholder: 'Nama Kategori', decoration: BoxDecoration(color: Colors.white.withOpacity(0.4))),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    pop(context);
                                  });
                                },
                                child: const Text('Simpan')),
                            TextButton(onPressed: () => pop(context), child: const Text('Batal')),
                          ],
                        ));
              },
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add)),
          body: FutureBuilder(
            future: Services().getKategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
              }
              return RefreshIndicator.adaptive(
                onRefresh: () async {},
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                    title: Text(snapshot.data![index]['nama']),
                    trailing: const Icon(Icons.border_color),
                    onTap: () {
                      var editKategori = TextEditingController(text: snapshot.data![index]['nama']);
                      showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: const Text('Ubah Kategori'),
                                content: CupertinoTextField(controller: editKategori, placeholder: 'Nama Kategori', decoration: BoxDecoration(color: Colors.white.withOpacity(0.4))),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          pop(context);
                                        });
                                      },
                                      child: const Text('Simpan')),
                                  TextButton(onPressed: () => pop(context), child: const Text('Batal')),
                                ],
                              ));
                    },
                  )),
                ),
              );
            },
          )),
    );
  }
}
