import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:path_provider/path_provider.dart';

class Product {
  static save(map) async {
    final jsonStr = jsonEncode(map);
    var path = await getTemporaryDirectory();
    File('${path.path}product.json').writeAsStringSync(jsonStr);
  }

  static Future<Map> get(storeId) async {
    var dir = await getTemporaryDirectory();
    var path = '${dir.path}/product-$storeId.json';

    print("PRODUCT : $path");

    var file = File(path);
    if (file.existsSync()) {
      final jsonStr = await file.readAsString();
      print("PRODUCT : fileExist");
      return jsonDecode(jsonStr);
    } else {
      var resp = await Services().getKatalogItem(storeId);
      print("PRODUCT : fileNotExist");
      final jsonStr = jsonEncode(resp);
      file.writeAsStringSync(jsonStr);
      return resp;
    }
  }

  static refresh(storeId) async {
    var dir = await getTemporaryDirectory();
    print("PRODUCT : refresh");
    try {
      var path = '${dir.path}/product-$storeId.json';

      await File(path).delete();
    } catch (e) {}
  }
}
