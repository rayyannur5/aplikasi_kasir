import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DetailTransaksi extends StatefulWidget {
  const DetailTransaksi({super.key, required this.id});
  final String id;

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  bool isConnect = false;
  Map data = {};

  Future getDevice() async {
    print(await printer.isOn);
    devices = await printer.getBondedDevices();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Column(
        children: [
          FutureBuilder(
            future: Services().getDetailTransaction(widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: Container(
                      height: size.height / 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      width: double.infinity,
                      color: Colors.white,
                    ));
              }
              if(!snapshot.data['success']){
                return Column(
                  children: [
                    Image.asset('assets/images/error.png'),
                    Text(snapshot.data['errors']),
                  ],
                );
              }
              data = snapshot.data['data'][0];
              int total = 0;
              for (int i = 0; i < data['items'].length; i++) {
                total = total + int.parse(data['items'][i]['price']);
              }
              return Container(
                height: size.height / 1.5,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(alignment: Alignment.center, child: Image.asset('assets/images/logo-black.png')),
                    Align(alignment: Alignment.center, child: Text(data['store'], style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),
                    Align(alignment: Alignment.center, child: Text(data['receipt_brand'], textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),
                    Align(alignment: Alignment.center, child: Text(data['receipt_phone'], textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),

                    Align(
                        alignment: Alignment.center,
                        child: Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(data['created_at'])), style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),
                    const SizedBox(height: 20),
                    Text("Kasir     : ${data['pegawai_name']}", style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold)),
                    Text("Pelanggan : ${data['customer']}", style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold)),
                    const Align(alignment: Alignment.center, child: Text("--------------------------------------", maxLines: 1, style: TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),
                    for (int i = 0; i < data['items'].length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${data['items'][i]['qty']}x ${data['items'][i]['product_name']}", style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold)),
                          Text(numberFormat.format(int.parse(data['items'][i]['price'])),
                              style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold)),
                        ],
                      ),
                    const Align(alignment: Alignment.center, child: Text("--------------------------------------", maxLines: 1, style: TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),
                    const Align(alignment: Alignment.center, child: Text('TOTAL', style: TextStyle(fontFamily: 'SpaceMono', fontSize: 20))),
                    Align(alignment: Alignment.center, child: Text(numberFormat.format(total), style: const TextStyle(fontFamily: 'SpaceMono', fontSize: 20, fontWeight: FontWeight.bold))),
                    const Align(alignment: Alignment.center, child: Text("--------------------------------------", maxLines: 1, style: TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),
                    const SizedBox(height: 20),
                    Align(alignment: Alignment.center, child: Text(data['receipt_message'], textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),
                    Align(alignment:Alignment.center, child: Text(data['trx_id'], style: const TextStyle(fontFamily: 'SpaceMono', fontWeight: FontWeight.bold))),

                  ],
                ),
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  bool? check = await printer.isOn;
                  if (check!) {
                    devices = await printer.getBondedDevices();
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                            padding: const EdgeInsets.all(20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: devices.length,
                              itemBuilder: (context, index) => Card(
                                child: ListTile(
                                  title: Text(devices[index].name!),
                                  subtitle: Text(devices[index].address!),
                                  onTap: () {},
                                ),
                              ),
                            )));
                  } else {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(padding: const EdgeInsets.all(20), width: size.width, child: const Text('Nyalakan Bluetooth Terlebih Dahulu', textAlign: TextAlign.center)));
                  }
                },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff107500))),
                child: const Text('Hubungkan Bluetooth')),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
                onPressed: !isConnect
                    ? null
                    : () async {
                        final ByteData logoBytes = await rootBundle.load(
                          'assets/images/logo-black.png',
                        );

                        int total = 0;
                        for (int i = 0; i < data['data'].length; i++) {
                          int temp = int.parse(data['data'][i]['item_count']) * int.parse(data['data'][i]['item_harga']);
                          total = total + temp;
                        }

                        final Uint8List logo = logoBytes.buffer.asUint8List(logoBytes.offsetInBytes, logoBytes.lengthInBytes);
                        printer.printImageBytes(logo);
                        printer.printCustom('-- ${data['outlet_nama']} --', 1, 1);
                        printer.printCustom(DateFormat("H:m, d MMMM yyyy", "id_ID").format(DateTime.parse(data['created_at'])), 1, 1);
                        printer.printNewLine();
                        printer.printCustom('Kasir     : ${data['user_nama']}', 1, 0);
                        printer.printCustom('ID        : ${data['id']}', 1, 0);
                        printer.printCustom('--------------------------------', 1, 1);
                        for (int i = 0; i < data['data'].length; i++) {
                          String namaProduk = "${data['data'][i]['item_count']}x ${data['data'][i]['item_nama']}";
                          if (namaProduk.length < 21) {
                            for (int i = namaProduk.length; i < 21; i++) {
                              namaProduk += ' ';
                            }
                          } else if (namaProduk.length > 21) {
                            namaProduk = namaProduk.substring(0, 21);
                          }
                          String harga = numberFormat.format(int.parse(data['data'][i]['item_harga']) * int.parse(data['data'][i]['item_count']));
                          String space = '';
                          if (harga.length == 4) {
                            space = '      ';
                          } else if (harga.length == 5) {
                            space = '     ';
                          } else if (harga.length == 6) {
                            space = '    ';
                          } else if (harga.length == 7) {
                            space = '   ';
                          } else if (harga.length == 8) {
                            space = '   ';
                          }
                          printer.printCustom('$namaProduk$space$harga', 1, 0);
                        }
                        printer.printCustom('TOTAL', 2, 1);
                        printer.printCustom(numberFormat.format(total).toString(), 2, 1);
                        printer.printCustom('--------------------------------', 1, 1);
                        printer.printCustom(data['outlet_pesan'], 1, 1);
                        printer.printNewLine();
                        printer.printNewLine();
                      },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff3943B7))),
                child: const Text('Cetak')),
          ),
          const SizedBox(height: 10),
        ],
      )),
    );
  }
}
