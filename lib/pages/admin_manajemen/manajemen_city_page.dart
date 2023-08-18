import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class ManajemenCityPage extends ConsumerWidget {
  const ManajemenCityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Kota')),
      drawer: DrawerAdmin(active: 5, size: size),
      floatingActionButton: FloatingActionButton(onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => showAddModal(context, ref)), child: const Icon(Icons.add)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureGetCitiesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ref.watch(futureGetCitiesProvider).when(
                  skipLoadingOnRefresh: false,
                  data: (result) {
                    if (result['success']) {
                      if (result['data'].isEmpty) {
                        return Image.asset('assets/images/empty.png');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: result['data'].length,
                        itemBuilder: (context, index) => Card(
                          elevation: 0,
                          color: const Color(0xffF6F6F6),
                          child: ListTile(
                            title: Text(result['data'][index]['name']),
                            trailing: const Icon(Icons.border_color),
                            onTap: () async {
                              Future.delayed(const Duration(milliseconds: 200));
                              showEditModal(context, ref, result['data'][index]);
                            },
                          ),
                        ),
                      );
                    } else {
                      return Image.asset("assets/images/error.png");
                    }
                  },
                  error: (error, stackTrace) => Image.asset("assets/images/error.png"),
                  loading: () => LottieBuilder.asset('assets/lotties/loading.json'),
                ),
          ],
        ),
      ),
    );
  }

  showEditModal(BuildContext context, ref, data) {
    TextEditingController name = TextEditingController(text: data['name']);
    bool isLoading = false;
    var editForm = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Form(
          key: editForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kolom tidak boleh kosong";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              const SizedBox(height: 10),
              StatefulBuilder(builder: (context, setstate) {
                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (editForm.currentState!.validate()) {
                            setstate(() => isLoading = true);
                            var res = await Services.updateCities(data['id'], name.text);
                            if (res['success']) {
                              ref.invalidate(futureGetCitiesProvider);
                              pop(context);
                            } else {
                              pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Text('Simpan'),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  showAddModal(BuildContext context, WidgetRef ref) {
    TextEditingController name = TextEditingController();
    bool isLoading = false;
    GlobalKey<FormState> addForm = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Form(
          key: addForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Kolom tidak boleh kosong";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setstate) {
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (addForm.currentState!.validate()) {
                              setstate(() => isLoading = true);
                              var res = await Services.addCities(name.text);
                              if (res['success']) {
                                ref.invalidate(futureGetCitiesProvider);
                                pop(context);
                              } else {
                                pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                              }
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text('Simpan'),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
