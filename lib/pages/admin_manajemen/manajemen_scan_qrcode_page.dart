import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_add_outlet_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRPage extends StatelessWidget {
  ScanQRPage({super.key});
  final MobileScannerController cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pop(context)), backgroundColor: Colors.red, foregroundColor: Colors.white, child: const Icon(Icons.close)),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              // final Uint8List? image = capture.image;
              cameraController.stop();
              showCupertinoDialog(context: context, builder: (context) => LottieBuilder.asset('assets/lotties/loading.json'));
              var resp = await Services().checkDevice(barcodes.first.rawValue);
              if (resp != null) {
                pop(context);
                pushReplacement(context, AddOutletPage(dataDevice: resp));
              } else {
                pop(context);
                await showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(content: const Text('Device Tidak Valid'), actions: [TextButton(onPressed: () => pop(context), child: const Text('Ok'))]));
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
