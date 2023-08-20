import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';


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
            data: (result) {
              if (!result['success']) {
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(futureGetShiftProvider);
                  },
                  child: ListView(
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(result['errors']),
                    ],
                  ),
                );
              }
              List data = result['data'];
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(futureGetShiftProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: data.length,
                  itemBuilder: (context, index) => Card(
                    color: const Color(0xffF6F6F6),
                    elevation: 0,
                    child: ExpansionTile(
                      title: Text(data[index]['store_name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                      children: [
                        ListTile(
                          title: const Text('Shift 1'),
                          subtitle: Text(data[index]['time_s1'].toString().substring(0, 5)),
                          onTap: () {
                            editModal(context, ref, data[index]['id'], data[index]['time_s1'], 1);
                          },
                          trailing: const Icon(Icons.border_color),
                        ),
                        ListTile(
                          title: const Text('Shift 2'),
                          subtitle: Text(data[index]['time_s2'].toString().substring(0, 5)),
                          onTap: () {
                            editModal(context, ref, data[index]['id'], data[index]['time_s2'], 2);
                          },
                          trailing: const Icon(Icons.border_color),
                        ),
                        ListTile(
                          title: const Text('Shift 3'),
                          subtitle: Text(data[index]['time_s3'].toString().substring(0, 5)),
                          onTap: () {
                            editModal(context, ref, data[index]['id'], data[index]['time_s3'], 3);
                          },
                          trailing: const Icon(Icons.border_color),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            error: (error, stackTrace) => const Center(child: Text('Gagal Ambil Data')),
            loading: () => Center(child: LottieBuilder.asset('assets/lotties/loading.json')),
          ),
    );
  }

  editModal(context, WidgetRef ref, id, String time, shift) async {
    TimeOfDay timeOfDay = TimeOfDay(hour: int.parse(time.substring(0, 2)), minute: int.parse(time.substring(3, 5)));
    var selectedTimeOfDay = await showTimePicker(context: context, initialTime: timeOfDay);
    if (selectedTimeOfDay != null) {
      showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
      var newTime = '${selectedTimeOfDay.format(context)}:00';
      print(newTime);
      var res = await Services.updateShift(id, newTime, shift);
      if (res['success']) {
        pop(context);
        ref.invalidate(futureGetShiftProvider);
      } else {
        pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
      }
    }
  }
}
