import 'package:aplikasi_kasir/pages/admin_dashboard/dashboard_page.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_ai_device_page.dart';
import 'package:aplikasi_kasir/pages/admin_laporan/laporan_transaksi/laporan_transaksi_year_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_layanan_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_outlet_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_petugas_page.dart';
import 'package:aplikasi_kasir/pages/admin_manajemen/manajemen_shift_page.dart';
import 'package:aplikasi_kasir/pages/auth/onboarding_page.dart';
import 'package:aplikasi_kasir/pages/katalog/katalog_page.dart';
import 'package:aplikasi_kasir/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/textstyles.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({
    super.key,
    required this.size,
    required this.active,
  });

  final Size size;
  final int active;

  void navigate(BuildContext context, int pos, Widget child) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (active == pos) {
        pop(context);
      } else {
        pushReplacement(context, child);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: size.width - 50,
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          DrawerHeader(
              child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', scale: 1.5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rayyan Nur Fauzan',
                    style: TextStyles.h2Light,
                  ),
                  Text(
                    'rayyannur5@gmail.com',
                    style: TextStyles.pLight,
                  ),
                ],
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.navigate_next, color: Colors.white)),
            ],
          )),
          ListTile(
            tileColor: active == 1 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.dashboard_outlined, color: Colors.white),
            title: Text('Dashboard', style: TextStyles.pBoldLight),
            onTap: () => navigate(context, 1, const DashboardPage()),
          ),
          ListTile(
            tileColor: active == 2 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.local_mall_outlined, color: Colors.white),
            title: Text('Katalog', style: TextStyles.pBoldLight),
            onTap: () => navigate(context, 2, KatalogPage()),
          ),
          ExpansionTile(
            collapsedBackgroundColor: active >= 3 && active <= 7 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            title: Text('Manajemen', style: TextStyles.pBoldLight),
            leading: const Icon(Icons.edit_document),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            children: [
              ListTile(
                tileColor: active == 3 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Layanan Dan Harga', style: TextStyles.pLight),
                onTap: () => navigate(context, 3, ManajemenLayananPage()),
              ),
              ListTile(
                tileColor: active == 4 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Karyawan/Petugas', style: TextStyles.pLight),
                onTap: () => navigate(context, 4, ManajemenPetugasPage()),
              ),
              ListTile(
                tileColor: active == 5 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Area/Kota', style: TextStyles.pLight),
                onTap: () {},
              ),
              ListTile(
                tileColor: active == 6 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Outlet/Cabang', style: TextStyles.pLight),
                onTap: () => navigate(context, 6, ManajemenOutletPage()),
              ),
              ListTile(
                tileColor: active == 7 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Jam Shift Outlet', style: TextStyles.pLight),
                onTap: () => navigate(context, 7, const ManajemenShiftPage()),
              ),
            ],
          ),
          ExpansionTile(
            collapsedBackgroundColor: active >= 8 && active <= 11 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.bookmarks_outlined),
            title: Text('Laporan', style: TextStyles.pBoldLight),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            children: [
              ListTile(
                tileColor: active == 8 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Ringkasan AI Device', style: TextStyles.pLight),
                onTap: () => navigate(context, 8, LaporanAIDevicePage()),
              ),
              ListTile(
                tileColor: active == 9 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Ringkasan Transaksi Penjualan', style: TextStyles.pLight),
                onTap: () => navigate(context, 9, AdminLaporanTransaksiPage()),
              ),
              ListTile(
                tileColor: active == 10 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Laporan Perbandingan', style: TextStyles.pLight),
                onTap: () {},
              ),
              ListTile(
                tileColor: active == 11 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Laporan Petugas', style: TextStyles.pLight),
                onTap: () {},
              ),
            ],
          ),
          ListTile(
            tileColor: active == 12 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.account_circle_outlined, color: Colors.white),
            title: Text('Profil Pengguna', style: TextStyles.pBoldLight),
            onTap: () {},
          ),
          ListTile(
            tileColor: active == 13 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.logout_outlined, color: Colors.white),
            title: Text('Logout', style: TextStyles.pBoldLight),
            onTap: () {
              pop(context);
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Apakah anda yakin untuk logout?'),
                  actions: [
                    TextButton(onPressed: () => pushAndRemoveUntil(context, const OnBoardingPage()), child: const Text('Logout')),
                    TextButton(onPressed: () => pop(context), child: const Text('Batal'))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
