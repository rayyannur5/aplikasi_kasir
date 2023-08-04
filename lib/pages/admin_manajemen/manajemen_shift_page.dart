import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_edit_shift_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../utils/textstyles.dart';

class ManajemenShiftPage extends ConsumerWidget {
  const ManajemenShiftPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Shift')),
      drawer: DrawerAdmin(active: 7, size: size),
      body: ref.watch(futureGetShiftProvider).when(
            skipLoadingOnRefresh: false,
            data: (data) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(futureGetShiftProvider);
              },
              child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: data.length,
                  itemBuilder: (context, index) => Card(
                      color: const Color(0xffF6F6F6),
                      child: ListTile(
                        title: Text(data[index]['nama'], style: TextStyles.h2),
                        subtitle: Text("${data[index]['start']} - ${data[index]['end']}"),
                        trailing: const Icon(Icons.border_color),
                        onTap: () => Future.delayed(const Duration(milliseconds: 200),
                            () => push(context, EditShiftPage(nama: data[index]['nama'], start: data[index]['start'], end: data[index]['end'], id: data[index]['id']))),
                      ))),
            ),
            error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
            loading: () => Center(child: LottieBuilder.asset('assets/lotties/loading.json')),
          ),
    );
  }
}
