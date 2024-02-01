import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_scan_qrcode_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/pick_location_page.dart';
import 'package:aplikasi_kasir/pages/payment_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../api/services.dart';
import '../../utils/textstyles.dart';

class ManajemenOutletPage extends StatefulWidget {
  ManajemenOutletPage({super.key});

  @override
  State<ManajemenOutletPage> createState() => _ManajemenOutletPageState();
}

class _ManajemenOutletPageState extends State<ManajemenOutletPage> {
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Outlet')),
      drawer: DrawerAdmin(size: size, active: 6),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 200), () => materialPush(context, ScanQRPage()));
            setState(() {});
          },
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add)),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
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
                    child: TextField(controller: search, textInputAction: TextInputAction.search, decoration: const InputDecoration(hintText: 'Cari Cabang/Outlet', prefixIcon: Icon(Icons.search))),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(height: 20, width: 20, color: Colors.red.shade100),
                Text('Outlet tidak aktif'),
                Container(height: 20, width: 20, color: Color(0xffF6F6F6)),
                Text('Outlet aktif'),
              ],
            ),

            FutureBuilder(
              future: Services().getOutlets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
                else if (!snapshot.data['success'])
                  return Center(child: Text(snapshot.data['errors']));
                else {
                  List data = snapshot.data['data'];

                  if (search.text.isNotEmpty) {
                    data = data.where((element) => element['name'].toString().toLowerCase().contains(search.text.toLowerCase())).toList();
                  }
                  return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) => Card(
                          color: data[index]['active'] == '1' ? const Color(0xffF6F6F6) : Colors.red.shade100,
                          child: ListTile(
                            title: Text("${data[index]['name']} | ${data[index]['city']}", style: TextStyles.h2),
                            subtitle: Text("${data[index]['expired_date']} \n ${data[index]['addr']}", style: TextStyle(fontSize: 12)),
                            trailing: const Icon(Icons.border_color),
                            onTap: () async {
                              await Future.delayed(const Duration(milliseconds: 200));
                              if (data[index]['active'] == '1') {
                                editModal(context, data[index]);
                              } else {
                                pembayaran(context, data[index]);
                              }
                            },
                          )));
                }
              },
            )
            // ref.watch(futureGetOutletsProvider).when(
            //       skipLoadingOnRefresh: false,
            //       data: (result) {
            //         if (!result['success']) {
            //           return Padding(
            //             padding: const EdgeInsets.all(20.0),
            //             child: Column(
            //               children: [
            //                 Image.asset("assets/images/error.png"),
            //                 Text(result['errors'], textAlign: TextAlign.center),
            //               ],
            //             ),
            //           );
            //         }
            //         List data = result['data'];
            //
            //         if (search.text.isNotEmpty) {
            //           data = data.where((element) => element['name'].toString().toLowerCase().contains(search.text.toLowerCase())).toList();
            //         }
            //         return ListView.builder(
            //             padding: const EdgeInsets.all(20),
            //             physics: const NeverScrollableScrollPhysics(),
            //             shrinkWrap: true,
            //             itemCount: data.length,
            //             itemBuilder: (context, index) => Card(
            //                 color: data[index]['active'] == '1' ? const Color(0xffF6F6F6) : Colors.red.shade100,
            //                 child: ListTile(
            //                   title: Text("${data[index]['name']} | ${data[index]['city']}", style: TextStyles.h2),
            //                   subtitle: Text(data[index]['addr']),
            //                   trailing: const Icon(Icons.border_color),
            //                   onTap: () async {
            //                     await Future.delayed(const Duration(milliseconds: 200));
            //                     editModal(context, ref, data[index]);
            //                   },
            //                 )));
            //       },
            //       error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
            //       loading: () => Center(child: LottieBuilder.asset('assets/lotties/loading.json')),
            //     ),
          ],
        ),
      ),
    );
  }

  pembayaran(context, data) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  var snapToken = await Services.getSnapToken(data['id']);
                  push(context, PaymentPage(snapToken: snapToken['data']));
                },
                child: Text('Bayar')),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  pop(context);
                  setState(() {});
                },
                child: Text('Refresh')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => pop(context), child: Text('Batal')),
          ],
        ),
      ),
    );
  }

  editModal(context, data) {
    var editOutlet = TextEditingController(text: data['name']);
    var lokasi = TextEditingController(text: "${data['lat']}, ${data['lat']}");
    double lat = double.parse(data['lat']);
    double lon = double.parse(data['lon']);
    String selectedCity = data['city_id'];
    var formKey = GlobalKey<FormState>();
    bool isLoading = false;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: editOutlet, validator: validationTextField, decoration: const InputDecoration(labelText: "Nama")),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(flex: 5, child: TextFormField(controller: lokasi, enabled: false, validator: validationTextField, decoration: const InputDecoration(labelText: "Lokasi"))),
                  Expanded(
                    child: IconButton(
                      onPressed: () async {
                        Future.delayed(const Duration(milliseconds: 200));
                        GeoPoint temp = await Navigator.push(context, MaterialPageRoute(builder: (context) => const PickLoactionPage()));
                        lat = temp.latitude;
                        lon = temp.longitude;
                        lokasi.text = "${temp.latitude}, ${temp.longitude}";
                      },
                      icon: const Icon(Icons.edit_location),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: Services().getCities(),
                builder: (context, res) {
                  if (!res.hasData) {
                    return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: const TextField());
                  }
                  List dataCity = res.data!['data'];
                  return DropdownButtonFormField(
                    value: selectedCity,
                    hint: const Text('Pilih Kota'),
                    validator: (value) {
                      if (value == null) {
                        return "Pilih Kota Terlebih Dahulu";
                      } else {
                        return null;
                      }
                    },
                    items: dataCity
                        .map((e) => DropdownMenuItem(
                              value: e['id'],
                              child: Text(e['name']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedCity = value.toString();
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              StatefulBuilder(builder: (context, setstate) {
                return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              setstate(() => isLoading = true);
                              var res = await Services.updateOutlet(data['id'], selectedCity, editOutlet.text, lat, lon);
                              setstate(() => isLoading = false);
                              if (res['success']) {
                                pop(context);
                                setState(() {});
                              } else {
                                pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                              }
                            }
                          },
                    child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)) : const Text('Simpan'));
              }),
            ],
          ),
        ),
      ),
    );

    // showCupertinoDialog(
    //     context: context,
    //     builder: (context) => StatefulBuilder(builder: (context, setState) {
    //           return CupertinoAlertDialog(
    //             title: const Text('Ubah Outlet'),
    //             content: Column(
    //               children: [
    //                 CupertinoTextField(controller: editOutlet, placeholder: 'Ubah Outlet', decoration: BoxDecoration(color: Colors.white.withOpacity(0.4))),
    //                 const SizedBox(height: 10),
    //                 CupertinoTextField(controller: lokasi, placeholder: 'Lokasi', enabled: false, decoration: BoxDecoration(color: Colors.white.withOpacity(0.4))),
    //                 const SizedBox(height: 10),
    //                 CupertinoButton.filled(
    //                     child: const Text('Pilih Lokasi'),
    //                     onPressed: () async {
    //                       GeoPoint temp = await Navigator.push(context, MaterialPageRoute(builder: (context) => const PickLoactionPage()));
    //                       setState(() {
    //                         lokasi.text = "${temp.latitude}, ${temp.longitude}";
    //                       });
    //                     }),
    //               ],
    //             ),
    //             actions: [
    //               TextButton(
    //                   onPressed: () {
    //                     pop(context);
    //                   },
    //                   child: const Text('Simpan')),
    //               TextButton(
    //                   onPressed: () {
    //                     pop(context);
    //                   },
    //                   child: const Text('Hapus')),
    //               TextButton(onPressed: () => pop(context), child: const Text('Batal')),
    //             ],
    //           );
    //         }));
  }

  String? validationTextField(value) {
    if (value!.isEmpty) {
      return "Kolom ini harus diisi";
    } else {
      return null;
    }
  }
}
