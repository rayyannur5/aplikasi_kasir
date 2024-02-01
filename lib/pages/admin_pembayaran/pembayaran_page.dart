import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      drawer: DrawerAdmin(active: 16, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: Services.getPayments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
            } else if (!snapshot.data['success']) {
              return ListView(
                children: [
                  Image.asset('assets/images/error.png'),
                  Text(snapshot.data['errors']),
                ],
              );
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: snapshot.data['data'].length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(snapshot.data['data'][index]['id']),
                    subtitle: Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(snapshot.data['data'][index]['created_at']))),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
                          child: Text(snapshot.data['data'][index]['amount']),
                        ),
                        const SizedBox(height: 2),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(color: getColor(snapshot.data['data'][index]['status']), borderRadius: BorderRadius.circular(10)),
                            child: Text(getString(snapshot.data['data'][index]['status']))),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Color getColor(index) {
    index = int.parse(index);
    if (index == 0)
      return Colors.grey.shade300;
    else if (index == 1)
      return Colors.green.shade300;
    else if (index == 2)
      return Colors.amber.shade300;
    else if (index == 3)
      return Colors.red.shade300;
    else
      return Colors.grey.shade300;
  }

  String getString(index) {
    index = int.parse(index);

    if (index == 0)
      return "Belum ada pembayaran";
    else if (index == 1)
      return "Sukses";
    else if (index == 2)
      return "Ditunda";
    else if (index == 3)
      return "Ditolak";
    else if (index == 4)
      return "Kadaluarsa";
    else if (index == 5)
      return "Dibatalkan";
    else if (index == 6)
      return "Kartu kredit tidak sah";
    else
      return "";
  }
}
