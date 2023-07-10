import 'package:flutter/material.dart';

abstract class TextStyles {
  static TextStyle h1 = const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle h1Light = const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle h2 = const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle h2Light = const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle h3 = const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  static TextStyle h3Light = const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle pBold = const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold);
}
