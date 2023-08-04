import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/katalog/sukses_pembayaran_page.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class PembayaranPage extends ConsumerWidget {
  PembayaranPage({super.key});
  List? items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    ref.watch(futureGetItemsProvider(1).selectAsync((data) {
      print(data);
      return items = data;
    }));
    int amount = ref.watch(amountProvider);
    int price = ref.watch(priceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            for (int i = 0; i < items!.length; i++)
              items![i]['count'] != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("\u2022 ${items![i]['nama']} \u2715 ${items![i]['count']}"),
                        Text(numberFormat.format(items![i]['count'] * int.parse(items![i]['harga'])).toString(), style: TextStyles.h2),
                      ],
                    )
                  : const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyles.h2Regular),
                Text(numberFormat.format(price).toString(), style: TextStyles.h2),
              ],
            ),
            const Spacer(),
            Container(
                width: size.width,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cash : '),
                    Text(numberFormat.format(amount).toString(), style: TextStyles.h1),
                  ],
                )),
            Container(
                width: size.width,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kembalian : '),
                    Text(numberFormat.format(amount - price).toString(), style: TextStyles.h1),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => ref.read(amountProvider.notifier).state = 5000,
                  child: Container(
                    height: 40,
                    width: size.width / 4 - 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    child: Text('5.000', style: TextStyles.h2),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(amountProvider.notifier).state = 10000,
                  child: Container(
                    height: 40,
                    width: size.width / 4 - 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    child: Text('10.000', style: TextStyles.h2),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(amountProvider.notifier).state = 20000,
                  child: Container(
                    height: 40,
                    width: size.width / 4 - 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    child: Text('20.000', style: TextStyles.h2),
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(amountProvider.notifier).state = 50000,
                  child: Container(
                    height: 40,
                    width: size.width / 4 - 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    child: Text('50.000', style: TextStyles.h2),
                  ),
                ),
              ],
            ),
            GridView.count(
              crossAxisCount: 4,
              physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,

              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}1';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('1', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}2';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('2', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}3';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('3', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        try {
                          String tempAmount = amount.toString();
                          tempAmount = tempAmount.substring(0, tempAmount.length - 1);
                          ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                        } catch (e) {
                          ref.read(amountProvider.notifier).state = 0;
                        }
                      },
                      child: Text('Del', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}4';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('4', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}5';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('5', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}6';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('6', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(onPressed: () => ref.read(amountProvider.notifier).state = 0, child: Text('C', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}7';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('7', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}8';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('8', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}9';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('9', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}0';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('0', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}00';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('00', style: TextStyles.h2)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width / 4 - 20,
                  child: TextButton(
                      onPressed: () {
                        String tempAmount = amount.toString();
                        tempAmount = '${tempAmount}000';
                        ref.read(amountProvider.notifier).state = int.parse(tempAmount);
                      },
                      child: Text('000', style: TextStyles.h2)),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'),
                    );
                    var resp = await Services.createTransactions("data");
                    if (resp) {
                      ref.invalidate(futureGetItemsProvider);
                      ref.invalidate(countItemProvider);
                      ref.invalidate(priceProvider);
                      pushAndRemoveUntil(context, const SuksesPembayaranPage());
                    }
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
