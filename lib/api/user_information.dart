import 'dart:convert';
import 'dart:io';

import 'package:aplikasi_kasir/api/services.dart';
import 'package:path_provider/path_provider.dart';

class UserInformation {
  static Future<Map> get() async {
    var dir = await getTemporaryDirectory();
    var path = '${dir.path}/user_information.json';

    var file = File(path);
    if (file.existsSync()) {
      final jsonStr = await file.readAsString();
      print("USER INFO : masuk read file");
      return jsonDecode(jsonStr);
    } else {
      var resp = await Services.getUserInformation();
      final jsonStr = jsonEncode(resp);
      file.writeAsStringSync(jsonStr);
      print("USER INFO : masuk write file");
      return resp;
    }
  }

  static delete() async {
    var dir = await getTemporaryDirectory();
    var path = '${dir.path}/user_information.json';

    var file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
