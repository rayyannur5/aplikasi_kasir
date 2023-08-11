import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/custom_icons.dart';

class ManajemenLayananHargaPage extends ConsumerWidget {
  const ManajemenLayananHargaPage({super.key, required this.outletId, required this.outletName});
  final String outletId;
  final String outletName;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Harga $outletName')),
      body: ref.watch(futureGetPricesProvider(outletId)).when(
            skipLoadingOnRefresh: false,
            data: (data) {
              if (data['success']) {
                if (data['data'].length == 0) {
                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(futureGetPricesProvider(outletId)),
                    child: ListView(children: [
                      const SizedBox(height: 100),
                      Image.asset('assets/images/empty.png'),
                    ]),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(futureGetPricesProvider(outletId));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: data['data'].length,
                    itemBuilder: (context, index) => Card(
                      color: const Color(0xffF6F6F6),
                      surfaceTintColor: const Color(0xffF6F6F6),
                      elevation: 5,
                      child: ListTile(
                        leading: CustomIcon(id: int.parse(data['data'][index]['icon'])),
                        title: Text(data['data'][index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['data'][index]['price'] != null ? (numberFormat.format(int.parse(data['data'][index]['price']))) : 'Belum ada harga'),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          priceBottomSheet(context, ref, data['data'][index], index);
                        },
                      ),
                    ),
                  ),
                );
              } else {
                Future.delayed(const Duration(milliseconds: 200), () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['errors']))));
                return Center(child: Image.asset('assets/images/error.png'));
              }
            },
            error: (error, stackTrace) => ListView(
              children: [Center(child: Image.asset('assets/images/error.png'))],
            ),
            loading: () => Center(child: LottieBuilder.asset('assets/lotties/loading.json')),
          ),
    );
  }

  Future<dynamic> priceBottomSheet(BuildContext context, WidgetRef ref, data, int index) {
    TextEditingController harga = TextEditingController(text: data['price']);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                    controller: harga,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Kolom tidak boleh kosong";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Harga')),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await Future.delayed(const Duration(milliseconds: 200));
                        showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
                        if (data['price'] == null) {
                          var res = await Services.createPrice(outletId, data['product_id'], harga.text);
                          if (res['success']) {
                            pop(context);
                            pop(context);
                            ref.invalidate(futureGetPricesProvider(outletId));
                          } else {
                            pop(context);
                            pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                          }
                        } else {
                          var res = await Services.updatePrice(data['id'], harga.text);
                          if (res['success']) {
                            pop(context);
                            pop(context);
                            ref.invalidate(futureGetPricesProvider(outletId));
                          } else {
                            pop(context);
                            pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['errors'])));
                          }
                        }
                      }
                    },
                    child: const Text('Simpan')),
              ],
            ),
          ),
        );
      },
    );
  }
}
