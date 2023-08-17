import 'package:shared_preferences/shared_preferences.dart';

class Local {
// REGISTER
  static Future setRegisterMode(String mode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('register_mode', mode);
  }

  static Future<String> getRegisterMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('register_mode') ?? 'user';
  }

  static Future<Map<String, dynamic>> getRegisterData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('register_mode') == 'admin') {
      return {
        'name': pref.getString('temp_register_name'),
        'email': pref.getString('temp_register_email'),
        'phone': pref.getString('temp_register_phone'),
        'password': pref.getString('temp_register_password'),
        'city': pref.getString('temp_city'),
        'profile_picture': 'https://picsum.photos/200/300',
      };
    } else {
      return {
        'name': pref.getString('temp_register_name'),
        'email': pref.getString('temp_register_email'),
        'phone': pref.getString('temp_register_phone'),
        'password': pref.getString('temp_register_password'),
        'refferal': pref.getString('temp_refferal'),
        'profile_picture': 'https://picsum.photos/200/300',
      };
    }
  }

// LOGIN
  static Future<Map> getLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return {
      'value': pref.getBool('is_login'),
      'role': pref.getString('user_role'),
    };
  }

  static Future setLogin(bool data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('is_login', data);
  }

// REGISTER LOGIN
  static Future setUserData(Map data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('user_id', data['id']);
    await pref.setString('user_name', data['name']);
    await pref.setString('user_email', data['email']);
    await pref.setString('user_phone', data['phone']);
    await pref.setString('user_profile_picture', data['profile_picture']);
    await pref.setString('user_role', data['role']);
  }

  static Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return {
      'user_id': pref.getString('user_id'),
      'user_name': pref.getString('user_name'),
      'user_email': pref.getString('user_email'),
      'user_profile_picture': pref.getString('user_profile_picture'),
      'user_phone': pref.getString('user_phone'),
      'user_role': pref.getString('user_role'),
    };
  }

  static Future setCityId(id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('temp_add_outlet_city_id', id);
  }

  static Future setReceiptData(Map data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('receipt_brand', data['receipt_brand']);
    await pref.setString('receipt_phone', data['receipt_phone']);
    await pref.setString('receipt_message', data['receipt_message']);
  }

  static userLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await setLogin(false);
    await pref.remove('user_nama');
    await pref.remove('user_email');
    await pref.remove('user_role');
    await pref.remove('user_phone');
    var keys = pref.getKeys();
    if (keys.contains('user_nama') || keys.contains('user_email') || keys.contains('user_role') || keys.contains('user_phone')) {
      return false;
    } else {
      return true;
    }
  }

  // OUTLET
  static Future getAddOutletData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return {
      'admin_id': pref.getString('user_id'),
      'device_id': pref.getString('temp_add_outlet_device_id'),
      'city_id': pref.getString('temp_add_outlet_city_id'),
      'name': pref.getString('temp_add_outlet_name'),
      'lat': pref.getDouble('temp_add_outlet_lat'),
      'lon': pref.getDouble('temp_add_outlet_lon'),
      'device_product_1': pref.getString('temp_add_outlet_device_product_1'),
      'device_product_2': pref.getString('temp_add_outlet_device_product_2'),
      'device_product_3': pref.getString('temp_add_outlet_device_product_3'),
      'device_product_4': pref.getString('temp_add_outlet_device_product_4'),
      'device_product_5': pref.getString('temp_add_outlet_device_product_5'),
      'device_product_6': pref.getString('temp_add_outlet_device_product_6'),
      'device_product_7': pref.getString('temp_add_outlet_device_product_7'),
      'device_product_8': pref.getString('temp_add_outlet_device_product_8'),
      'device_product_9': pref.getString('temp_add_outlet_device_product_9'),
      'device_product_10': pref.getString('temp_add_outlet_device_product_10'),
      'device_product_11': pref.getString('temp_add_outlet_device_product_11'),
      'device_product_12': pref.getString('temp_add_outlet_device_product_12'),
      'device_product_13': pref.getString('temp_add_outlet_device_product_13'),
      'device_product_14': pref.getString('temp_add_outlet_device_product_14'),
    };
  }
}
