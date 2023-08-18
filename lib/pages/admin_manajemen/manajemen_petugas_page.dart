import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class ManajemenPetugasPage extends ConsumerWidget {
  ManajemenPetugasPage({super.key});
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Petugas')),
      drawer: DrawerAdmin(size: size, active: 4),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Consumer(
                          builder: (context, ref, child) {
                            return CupertinoAlertDialog(
                              title: const Text('Kode Referral'),
                              content: ref.watch(futureGetKodeReferralProvider).when(
                                    data: (result) {
                                      if (result['success']) {
                                        var data = result['data'];
                                        return Column(
                                          children: [Text(data[0]['refferal']), SizedBox(height: 100, width: 100, child: QrImageView(data: data[0]['refferal']))],
                                        );
                                      } else {
                                        return Text(result['errors']);
                                      }
                                    },
                                    error: (error, stackTrace) => const Text('Gagal Ambil Data'),
                                    loading: () => Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Container(color: Colors.black, height: 18)),
                                  ),
                              actions: [
                                TextButton(
                                    onPressed: () => Share.share("Berikut kode refferal anda: \n" + ref.watch(futureGetKodeReferralProvider).asData!.value['data'][0]['refferal']),
                                    child: const Text("Share")),
                                TextButton(onPressed: () => pop(context), child: const Text("Batal")),
                              ],
                            );
                          },
                        ));
              },
              child: const Text('Kode Referral'))),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureGetEmployeesProvider);
          ref.invalidate(futureGetKodeReferralProvider);
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
                        onSubmitted: (_) => ref.invalidate(futureGetEmployeesProvider),
                        decoration: const InputDecoration(hintText: 'Cari Petugas/Karyawan', prefixIcon: Icon(Icons.search))),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(height: 10, width: 10, color: const Color(0xFFFFBABA)),
                    const SizedBox(width: 10),
                    const Text('Belum diverifikasi'),
                  ],
                ),
                Row(
                  children: [
                    Container(height: 10, width: 10, color: const Color(0xffF6F6F6)),
                    const SizedBox(width: 10),
                    const Text('Sudah diverifikasi'),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
            ref.watch(futureGetEmployeesProvider).when(
                  skipLoadingOnRefresh: false,
                  data: (result) {
                    if (!result['success']) {
                      Future.delayed(const Duration(milliseconds: 200), () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['errors']))));
                      return Center(
                        child: Image.asset('assets/images/error.png'),
                      );
                    }
                    List data = result['data'];

                    if (data.isEmpty) {
                      return Padding(padding: const EdgeInsets.only(top: 100), child: Image.asset('assets/images/empty.png'));
                    }

                    if (search.text.isNotEmpty) {
                      data = data.where((element) => element['name'].toString().toLowerCase().contains(search.text.toLowerCase())).toList();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) => Card(
                        color: data[index]['active'] == '1' ? const Color(0xffF6F6F6) : const Color(0xFFFFBABA),
                        elevation: 0,
                        child: ListTile(
                          title: Text(data[index]['name'], style: TextStyles.h2),
                          subtitle: Text(data[index]['email']),
                          trailing: data[index]['active'] == '0' ? const Icon(Icons.border_color) : const SizedBox(),
                          onTap: () async {
                            if (data[index]['active'] == '0') {
                              verifikasi(context, ref, data[index]['id']);
                            }
                          },
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
                  loading: () => Center(child: LottieBuilder.asset('assets/lotties/loading.json')),
                ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  Future verifikasi(BuildContext context, WidgetRef ref, pegawaiId) async {
    Future.delayed(const Duration(milliseconds: 200));
    bool isLoadingVerifikasi = false;
    bool isLoadingHapus = false;
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setstate) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: isLoadingHapus
                      ? null
                      : () async {
                          setstate(() => isLoadingHapus = true);
                          var res = await Services.verifyPegawai(pegawaiId, 0);
                          if (res['success']) {
                            setstate(() => isLoadingHapus = false);
                            pop(context);
                            ref.invalidate(futureGetEmployeesProvider);
                          } else {
                            pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                          }
                        },
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  child: isLoadingHapus ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()) : const Text('Hapus')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: isLoadingVerifikasi
                      ? null
                      : () async {
                          setstate(() => isLoadingVerifikasi = true);
                          var res = await Services.verifyPegawai(pegawaiId, 1);
                          if (res['success']) {
                            setstate(() => isLoadingVerifikasi = false);
                            pop(context);
                            ref.invalidate(futureGetEmployeesProvider);
                          } else {
                            pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                          }
                        },
                  child: isLoadingVerifikasi ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()) : const Text('Verifikasi')),
            ],
          ),
        );
      }),
    );
  }
}
