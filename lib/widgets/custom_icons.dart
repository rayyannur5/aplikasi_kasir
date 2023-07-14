import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  CustomIcon({super.key, required this.id});

  final int id;

  final List assets = [
    'assets/icons/ban-1.png',
    'assets/icons/ban-2.png',
    'assets/icons/ban-3.png',
    'assets/icons/ban-4.png',
    'assets/icons/motor-1.png',
    'assets/icons/motor-2.png',
    'assets/icons/mobil-1.png',
    'assets/icons/mobil-2.png',
    'assets/icons/mobil-3.png',
    'assets/icons/dll-1.png',
    'assets/icons/dll-2.png',
    'assets/icons/dll-3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Image.asset(assets[id]),
    );
  }
}
