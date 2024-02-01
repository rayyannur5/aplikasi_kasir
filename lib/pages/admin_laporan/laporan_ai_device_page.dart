import 'package:aplikasi_kasir/api/providers.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/utils/formatter.dart';
import 'package:aplikasi_kasir/utils/textstyles.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_two_lines_with_label.dart';
import 'package:aplikasi_kasir/widgets/custom_chart_with_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/custom_chart_four_lines_with_label.dart';

class LaporanAIDevicePage extends StatefulWidget {
  LaporanAIDevicePage({super.key});

  @override
  State<LaporanAIDevicePage> createState() => _LaporanAIDevicePageState();
}

class _LaporanAIDevicePageState extends State<LaporanAIDevicePage> {
  var _date = DateTime.now();

  bool first = true;

  var selectedOutlet = '0';

  final PagingController _paging0Controller = PagingController(firstPageKey: 1);
  final PagingController _paging2Controller = PagingController(firstPageKey: 1);
  final PagingController _paging4Controller = PagingController(firstPageKey: 1);
  final PagingController _paging6Controller = PagingController(firstPageKey: 1);
  final PagingController _paging8Controller = PagingController(firstPageKey: 1);
  final PagingController _paging10Controller = PagingController(firstPageKey: 1);
  final PagingController _paging12Controller = PagingController(firstPageKey: 1);
  final PagingController _paging14Controller = PagingController(firstPageKey: 1);
  final PagingController _paging16Controller = PagingController(firstPageKey: 1);
  final PagingController _paging18Controller = PagingController(firstPageKey: 1);
  final PagingController _paging20Controller = PagingController(firstPageKey: 1);
  final PagingController _paging22Controller = PagingController(firstPageKey: 1);

  @override
  void initState() {
    // TODO: implement initState
    _paging0Controller.addPageRequestListener((pageKey) {
      fetch(_paging0Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 0));
    });
    _paging2Controller.addPageRequestListener((pageKey) {
      fetch(_paging2Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 2));
    });
    _paging4Controller.addPageRequestListener((pageKey) {
      fetch(_paging4Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 4));
    });
    _paging6Controller.addPageRequestListener((pageKey) {
      fetch(_paging6Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 6));
    });
    _paging8Controller.addPageRequestListener((pageKey) {
      fetch(_paging8Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 8));
    });
    _paging10Controller.addPageRequestListener((pageKey) {
      fetch(_paging10Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 10));
    });
    _paging12Controller.addPageRequestListener((pageKey) {
      fetch(_paging12Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 12));
    });
    _paging14Controller.addPageRequestListener((pageKey) {
      fetch(_paging14Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 14));
    });
    _paging16Controller.addPageRequestListener((pageKey) {
      fetch(_paging16Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 16));
    });
    _paging18Controller.addPageRequestListener((pageKey) {
      fetch(_paging18Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 18));
    });
    _paging20Controller.addPageRequestListener((pageKey) {
      fetch(_paging20Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 20));
    });
    _paging22Controller.addPageRequestListener((pageKey) {
      fetch(_paging22Controller, pageKey, DateTime(_date.year, _date.month, _date.day, 22));
    });
    super.initState();
  }

  Future fetch(controller, pageKey, date) async {
    final newItems = await Services.getDeviceRealtime(date, selectedOutlet, pageKey);
    if (newItems['success']) {
      final isLastPage = newItems['data'].length < 10;
      if (isLastPage) {
        controller.appendLastPage(newItems['data']);
      } else {
        final nextPageKey = pageKey + newItems['data'].length as int;
        controller.appendPage(newItems['data'], nextPageKey);
      }
    } else {
      controller.error = newItems['errors'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan AI Device')),
      drawer: DrawerAdmin(active: 8, size: size),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            FutureBuilder(
              future: Services().getOutlets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Container(height: 55, color: Colors.black));
                } else if (!snapshot.data['success']) {
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data['errors']),
                    ],
                  );
                } else {
                  List data = snapshot.data['data'];
                  if (first) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        selectedOutlet = data.first['id'];
                      });
                    });
                    first = false;
                  }
                  return DropdownButtonFormField(
                    items: data.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']))).toList(),
                    value: selectedOutlet,
                    onChanged: (value) {
                      setState(() {
                        selectedOutlet = value.toString();
                      });
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.date_range_outlined),
                title: Text(DateFormat("d MMMM yyyy", "id_ID").format(_date), style: TextStyles.p),
                onTap: () async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  try {
                    var date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
                    if (date != null) {
                      setState(() {
                        _date = date;
                      });
                    }
                  } catch (e) {}
                },
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: Services().getAIDevice(_date, selectedOutlet),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 200, width: size.width - 40)));
                } else if (!snapshot.data!['success']) {
                  return Column(
                    children: [
                      Image.asset('assets/images/error.png'),
                      Text(snapshot.data!['errors']),
                    ],
                  );
                } else {
                  List data = snapshot.data['data'];
                  return Column(
                    children: [
                      FutureBuilder(
                        future: Services.getGrafikMesin(_date, selectedOutlet),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Shimmer.fromColors(baseColor: Colors.transparent, highlightColor: Colors.white.withOpacity(0.5), child: Card(child: SizedBox(height: 300, width: size.width - 40)));
                          } else if (!snapshot.data['success']) {
                            return Column(
                              children: [
                                Image.asset('assets/images/error.png'),
                                Text(snapshot.data['errors']),
                              ],
                            );
                          }

                          List dataGrafik = snapshot.data['data'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text('Grafik Data Mesin'),
                              ),
                              const SizedBox(height: 10),
                              CustomChart4LinesWithLabel(data: dataGrafik),
                              Row(
                                children: [
                                  Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: Theme.of(context).primaryColor),
                                  Text('Tambah Angin Motor'),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: const Color(0xff159600)),
                                  Text('Tambah Angin Mobil'),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: Colors.red),
                                  Text('Isi Baru Motor'),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(height: 20, width: 20, margin: EdgeInsets.only(right: 20), color: Colors.amber),
                                  Text('Isi Baru Mobil'),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Ringkasan Data Mesin'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: data
                                    .map<Widget>((e) => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${e['qty']}x ${e['name']}", style: TextStyles.pBold),
                                            Text(numberFormat.format(int.parse(e['qty']) * int.parse(e['price']))),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DefaultTabController(
                        length: 12,
                        initialIndex: getIndex(),
                        child: Column(
                          children: [
                            const TabBar(isScrollable: true, tabs: [
                              Tab(child: Text('00:00 ~ 01:59')),
                              Tab(child: Text('02:00 ~ 03:59')),
                              Tab(child: Text('04:00 ~ 05:59')),
                              Tab(child: Text('06:00 ~ 07:59')),
                              Tab(child: Text('08:00 ~ 09:59')),
                              Tab(child: Text('10:00 ~ 11:59')),
                              Tab(child: Text('12:00 ~ 13:59')),
                              Tab(child: Text('14:00 ~ 15:59')),
                              Tab(child: Text('16:00 ~ 17:59')),
                              Tab(child: Text('18:00 ~ 19:59')),
                              Tab(child: Text('20:00 ~ 21:59')),
                              Tab(child: Text('22:00 ~ 23:59')),
                            ]),
                            SizedBox(
                              height: 400,
                              child: TabBarView(children: [
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 0)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 2)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 4)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 6)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 8)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 10)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 12)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 14)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 16)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 18)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 20)),
                                getDeviceRealtime(DateTime(_date.year, _date.month, _date.day, 22)),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getDeviceRealtime(date) {
    var controller = ScrollController();
    ValueNotifier<bool> _notifier = ValueNotifier(false);

    int page = 1;
    bool firstLoading = true;
    bool isFinish = false;
    bool isError = false;
    String error = "";
    List items = [];

    fetchData(page) async {
      var res = await Services.getDeviceRealtime(date, selectedOutlet, page);
      if (res['success']) {
        for (int i = 0; i < res['data'].length; i++) {
          items.add(res['data'][i]);
        }
        List dataBaru = res['data'];
        if (dataBaru.isEmpty) {
          print('sudah finish');
          isFinish = true;
        }
        firstLoading = false;
        _notifier.value = !_notifier.value;
      } else {
        print(res['errors']);
        isError = true;
        firstLoading = false;
        error = res['errors'];
        _notifier.value = !_notifier.value;
      }
    }

    fetchData(1);

    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
        print('Sampai bawah');
        if (!isFinish) {
          page++;
          fetchData(page);
        }
      }
    });

    return ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (context, value, child) {
          if (isError) {
            return RefreshIndicator(
                child: ListView(
                  children: [
                    Image.asset('assets/images/error.png'),
                    Text(error),
                  ],
                ),
                onRefresh: () async {
                  items = [];
                  isFinish = false;
                  firstLoading = true;
                  isError = false;
                  _notifier.value = !_notifier.value;
                  await fetchData(1);
                });
          }

          if (firstLoading) {
            return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
          }
          if (items.isEmpty) {
            return RefreshIndicator(
                child: ListView(
                  children: [
                    Image.asset('assets/images/empty.png'),
                  ],
                ),
                onRefresh: () async {
                  items = [];
                  isFinish = false;
                  firstLoading = true;
                  isError = false;
                  _notifier.value = !_notifier.value;
                  await fetchData(1);
                });
          }

          return RefreshIndicator(
            onRefresh: () async {
              items = [];
              isFinish = false;
              firstLoading = true;
              isError = false;
              _notifier.value = !_notifier.value;
              await fetchData(1);
            },
            child: ListView.builder(
              controller: controller,
              itemCount: isFinish ? items.length : items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length && !isFinish) {
                  return SizedBox(height: 40, child: CupertinoActivityIndicator());
                }
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(items[index]['name']),
                    subtitle: Text(DateFormat("HH:mm, d MMMM yyyy", "id_ID").format(DateTime.parse(items[index]['created_at']))),
                  ),
                );
              },
            ),
          );
        });
  }

  int getIndex() {
    var date = DateTime.now();
    int hour = date.hour;
    int index = (hour / 2).toInt();
    return index;
  }
}
