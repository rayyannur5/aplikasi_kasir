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

  Future<List<Map>> getItems() async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map> hasil = [
      {
        'id': '1',
        'nama': 'Tambah Angin Motor',
        'kategori': '1',
        'harga': '3000',
        'icon': '1',
      },
      {
        'id': '2',
        'nama': 'Tambah Angin Mobil',
        'kategori': '2',
        'harga': '5000',
        'icon': '1',
      },
      {
        'id': '3',
        'nama': 'Ganti Angin Motor',
        'kategori': '1',
        'harga': '7000',
        'icon': '2',
      },
      {
        'id': '4',
        'nama': 'Ganti Angin Mobil',
        'kategori': '2',
        'harga': '9000',
        'icon': '2',
      },
      {
        'id': '5',
        'nama': 'Tambal Ban Motor',
        'kategori': '1',
        'harga': '10000',
        'icon': '3',
      },
      {
        'id': '6',
        'nama': 'Tambal Ban Mobil',
        'kategori': '2',
        'harga': '20000',
        'icon': '3',
      },
    ];

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
}
