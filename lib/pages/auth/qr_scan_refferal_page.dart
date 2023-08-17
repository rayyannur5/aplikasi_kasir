import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRRefferal extends StatelessWidget {
  QRRefferal({super.key});

  final MobileScannerController cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              cameraController.stop();

              final List<Barcode> barcodes = capture.barcodes;

              Navigator.pop(context, barcodes.first.rawValue);
            },
          ),
          SizedBox(height: size.height, width: size.width, child: Image.asset('assets/images/qr.png', fit: BoxFit.cover)),
        ],
      ),
    );
  }
}
