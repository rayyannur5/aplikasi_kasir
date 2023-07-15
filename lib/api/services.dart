import 'dart:math';

class Services {
  final String _uri = "";

  static login(email, password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static createTransactions(data) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static addItems(icon, name, harga, kategori) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static addShift(nama, start, end) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static updateShift(nama, start, end) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static checkDevice(id) async {
    await Future.delayed(const Duration(seconds: 1));
    if (id == "XaXadd") {
      return {
        'id': 'XaXadd',
        'nama': 'Perangkat SPBU Generator',
      };
    } else {
      return null;
    }
  }

  static addOutlet(dataDevice, nama) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<int> getCountDeviceTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(1000);
  }

  Future<int> getCountCashierTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(100);
  }

  Future<int> getOpenedOutlets() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(10);
  }

  Future<int> getActivedEmployees() async {
    await Future.delayed(const Duration(seconds: 1));
    return Random().nextInt(10);
  }

  Future<Map> getOmsetComparison() async {
    await Future.delayed(const Duration(seconds: 1));
    var hasil = {'kasir': '10.000', 'device': '10.000'};
    return hasil;
  }

  Future<List<double>> getChartTodayTransactions() async {
    await Future.delayed(const Duration(seconds: 1));
    List<double> hasil = [
      0,
      0,
      0,
      0,
      5,
      6,
      2,
      8,
      10,
      3,
      6,
      0,
      7,
      9,
      11,
      1,
      3,
      4,
      0,
      0,
      0,
      0,
      0,
      0,
    ];
    return hasil;
  }

  Future<List<Map>> getItems(outlet_id) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Tambah Angin Motor',
        'kategori': '1',
        'harga': '3000',
        'icon': '1',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '2',
        'nama': 'Tambah Angin Mobil',
        'kategori': '2',
        'harga': '5000',
        'icon': '1',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '3',
        'nama': 'Ganti Angin Motor',
        'kategori': '1',
        'harga': '7000',
        'icon': '2',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '4',
        'nama': 'Ganti Angin Mobil',
        'kategori': '2',
        'harga': '9000',
        'icon': '2',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '5',
        'nama': 'Tambal Ban Motor',
        'kategori': '1',
        'harga': '10000',
        'icon': '3',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
      {
        'id': '6',
        'nama': 'Tambal Ban Mobil',
        'kategori': '2',
        'harga': '20000',
        'icon': '3',
        'outlet_id': '1',
        'outlet_nama': 'Outlet 1',
      },
    ];

    hasil = hasil.where((element) => element['outlet_id'] == outlet_id.toString()).toList();

    return hasil;
  }

  Future<List<Map>> getKategories() async {
    await Future.delayed(const Duration(seconds: 1));
    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Motor',
      },
      {
        'id': '2',
        'nama': 'Mobil',
      },
      {
        'id': '3',
        'nama': 'Lain - lain',
      },
    ];
    return hasil;
  }

  Future<List<Map>> getEmployees(String keyword) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Budi Santoso',
        'email': 'budi@gmail.com',
      },
      {
        'id': '2',
        'nama': 'Panji',
        'email': 'panji@gmail.com',
      },
      {
        'id': '3',
        'nama': 'Rendi',
        'email': 'rendi@gmail.com',
      },
    ];

    hasil = hasil.where((element) => element['nama'].toString().toLowerCase().contains(keyword.toLowerCase())).toList();

    return hasil;
  }

  Future<String> getKodeReferral() async {
    await Future.delayed(const Duration(seconds: 1));

    return "Axd679";
  }

  Future<List<Map>> getOutlets(String keyword) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Outlet 1',
        'mesin_id': 'asRf2',
      },
      {
        'id': '2',
        'nama': 'Outlet 2',
        'mesin_id': 'asRf2',
      },
      {
        'id': '3',
        'nama': 'Outlet 3',
        'mesin_id': 'asRf2',
      },
    ];

    hasil = hasil.where((element) => element['nama'].toString().toLowerCase().contains(keyword.toLowerCase())).toList();

    return hasil;
  }

  Future<List<Map>> getShift() async {
    await Future.delayed(const Duration(seconds: 1));
    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Shift 1',
        'start': '00:00',
        'end': '09:59',
      },
      {
        'id': '2',
        'nama': 'Shift 2',
        'start': '10:00',
        'end': '15:59',
      },
      {
        'id': '3',
        'nama': 'Shift 3',
        'start': '16:00',
        'end': '21:59',
      },
    ];
    return hasil;
  }
}
