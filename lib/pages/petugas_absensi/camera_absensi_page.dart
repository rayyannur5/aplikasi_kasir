import 'dart:io';

import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/pages/petugas_absensi/create_absensi_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class CameraAbsensiPage extends StatefulWidget {
  const CameraAbsensiPage({super.key});

  @override
  State<CameraAbsensiPage> createState() => _CameraAbsensiPageState();
}

class _CameraAbsensiPageState extends State<CameraAbsensiPage> {
  late CameraController controller;

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.low);
    await controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  File changeFileNameOnlySync(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.renameSync(newPath);
  }

  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          // height: size.height - 100,
          // width: size.width,

              child : FutureBuilder(
                future: initializeCamera(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return SizedBox(height: size.height/2, child: LottieBuilder.asset('assets/lotties/loading.json'));
                  return CameraPreview(controller);
                },
              ),
        ),
        const Spacer(),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(onPressed: () => Future.delayed(const Duration(milliseconds: 200), () => pop(context)), heroTag: 'close', backgroundColor: Colors.red, child: const Icon(Icons.close)),
              FutureBuilder<Position>(
                  future: getPosition(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const FloatingActionButton(onPressed: null, child: CupertinoActivityIndicator(color: Colors.white));
                    return FloatingActionButton(
                        onPressed: () async {
                          final image = await controller.takePicture();

                          var userData = await Local.getUserData();
                          var idUser = userData['user_id'];
                          int idUser1000 = 1000 + int.parse(idUser);

                          var date = DateTime.now();
                          var year = date.year.toString();
                          var month = date.month < 10 ? '0${date.month.toString()}' : date.month.toString();
                          var day = date.day < 10 ? '0${date.day.toString()}' : date.day.toString();
                          var hour = date.hour < 10 ? '0${date.hour.toString()}' : date.hour.toString();
                          var minute = date.minute < 10 ? '0${date.minute.toString()}' : date.minute.toString();
                          var second = date.second < 10 ? '0${date.second.toString()}' : date.second.toString();

                          var namaGambar = '$idUser1000$year$month$day$hour$minute$second.jpg';

                          File newImage = changeFileNameOnlySync(File(image.path), namaGambar);

                          pushReplacement(context, CreateAbsensiPage(imagePath: newImage.path, position: snapshot.data!));
                        },
                        heroTag: 'camera',
                        child: const Icon(Icons.camera));
                  }),
              const SizedBox(width: 60),
            ],
          ),
        )
      ],
    );
  }
}
