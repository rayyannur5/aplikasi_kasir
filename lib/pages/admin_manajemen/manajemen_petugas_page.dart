import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class ManajemenPetugasPage extends ConsumerWidget {
  ManajemenPetugasPage({super.key});
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen Petugas')),
      drawer: DrawerAdmin(size: size, active: 4),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Consumer(
                          builder: (context, ref, child) {
                            return CupertinoAlertDialog(
                              title: Text('Kode Referral'),
                              content: ref.watch(futureGetKodeReferralProvider).when(
                                    data: (data) => Text(data),
                                    error: (error, stackTrace) => Text('Gagal Ambil Data'),
                                    loading: () => Shimmer.fromColors(child: Container(color: Colors.black, height: 18), baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5)),
                                  ),
                              actions: [
                                TextButton(onPressed: () => Share.share(ref.watch(futureGetKodeReferralProvider).asData!.value, subject: 'Kode Referral'), child: Text("Share")),
                                TextButton(onPressed: () => pop(context), child: Text("Batal")),
                              ],
                            );
                          },
                        ));
              },
              child: Text('Kode Referral'))),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(futureGetEmployeesProvider);
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
            ref.watch(futureGetEmployeesProvider(search.text)).when(
                  skipLoadingOnRefresh: false,
                  data: (data) => ListView.builder(
                      padding: EdgeInsets.all(20),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) => Card(
                          color: Color(0xffF6F6F6),
                          child: ListTile(
                            title: Text(data[index]['nama'], style: TextStyles.h2),
                            subtitle: Text(data[index]['email']),
                            trailing: Icon(Icons.border_color),
                            onTap: () {},
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
