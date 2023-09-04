import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Trolly {
  static push(Map newData) async {
    var dir = await getTemporaryDirectory();
    var path = '${dir.path}/trolly.json';
    var file = File(path);
    List temp = [];

    if (file.existsSync()) {
      String jsonStr = file.readAsStringSync();
      temp = jsonDecode(jsonStr);
      temp.add(newData);
      jsonStr = jsonEncode(temp);
      file.writeAsStringSync(jsonStr);
    } else {
      temp.add(newData);
      final jsonStr = jsonEncode(temp);
      file.writeAsStringSync(jsonStr);
    }
  }

  static getAll() async {
    var dir = await getTemporaryDirectory();
    var path = '${dir.path}/trolly.json';
    var file = File(path);
    if (file.existsSync()) {
      final jsonStr = file.readAsStringSync();
      return jsonDecode(jsonStr);
    } else {
      return [];
    }
  }

  static remove(String id) async {
    var dir = await getTemporaryDirectory();
    var path = '${dir.path}/trolly.json';
    var file = File(path);
    if (file.existsSync()) {
      String jsonStr = file.readAsStringSync();
      List data = jsonDecode(jsonStr);
      data = data.where((element) => element['trx_id'] != id).toList();
      jsonStr = jsonEncode(data);
      file.writeAsStringSync(jsonStr);
    }
  }
}
