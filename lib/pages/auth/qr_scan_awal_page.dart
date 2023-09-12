import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/auth/pegawai_refferal_page.dart';
import 'package:aplikasi_kasir/pages/auth/take_photo_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRAwalPage extends StatelessWidget {
  ScanQRAwalPage({super.key});
  final MobileScannerController cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          const SizedBox(width: 20),
          FloatingActionButton(
              onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pop(context)),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: const Icon(Icons.close)),
          const SizedBox(width: 20),
          Expanded(
              child: ElevatedButton(
                  onPressed: () async {
                    await Local.setRegisterMode('user');
                    await Future.delayed(const Duration(milliseconds: 200));
                    pushReplacement(context, InputKodeRefferalPage());
                  },
                  child: const Text("Daftar Sebagai Pegawai"))),
          const SizedBox(width: 20),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              // final Uint8List? image = capture.image;
              cameraController.stop();
              showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
              Map resp = await Services().checkDevice(barcodes.first.rawValue);
              if (resp['success']) {
                pop(context);
                await Local.setRegisterMode('admin');
                pushReplacement(context, TakePhotoPage(dataDevice: resp));
              } else {
                pop(context);
                await showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                        content: Text(resp['errors'].toString()), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
                cameraController.start();
              }
            },
          ),
          SizedBox(height: size.height, width: size.width, child: Image.asset('assets/images/qr.png', fit: BoxFit.cover)),
        ],
      ),
    );
  }
}
