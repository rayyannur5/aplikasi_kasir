import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Product {
  static save(map) async {
    final jsonStr = jsonEncode(map);
    var path = await getTemporaryDirectory();
    File(path.path + 'product.json').writeAsStringSync(jsonStr);
  }
}
