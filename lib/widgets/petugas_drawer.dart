import 'package:aplikasi_kasir/pages/petugas_absensi/petugas_absensi_page.dart';
import 'package:aplikasi_kasir/pages/petugas_laporan/petugas_laporan_absensi_page.dart';
import 'package:aplikasi_kasir/pages/petugas_laporan/petugas_laporan_penjualan_page.dart';
import 'package:aplikasi_kasir/pages/petugas_laporan/petugas_laporan_setoran_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/local.dart';
import '../pages/auth/onboarding_page.dart';
import '../pages/auth/profil_pengguna_page.dart';
import '../pages/katalog/katalog_page.dart';
import '../utils/navigator.dart';
import '../utils/textstyles.dart';

class DrawerPetugas extends StatelessWidget {
  const DrawerPetugas({
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
              FutureBuilder<Map>(
                  future: Local.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox();
                    var data = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['user_nama'],
                          style: TextStyles.h2Light,
                        ),
                        Text(
                          data['user_email'],
                          style: TextStyles.pLight,
                        ),
                      ],
                    );
                  }),
              const Spacer(),
              IconButton(onPressed: () => navigate(context, 6, const ProfilPenggunaPage()), icon: const Icon(Icons.navigate_next, color: Colors.white)),
            ],
          )),
          ListTile(
            tileColor: active == 1 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.local_mall_outlined, color: Colors.white),
            title: Text('Katalog', style: TextStyles.pBoldLight),
            onTap: () => navigate(context, 1, KatalogPage()),
          ),
          ListTile(
            tileColor: active == 2 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.qr_code_scanner, color: Colors.white),
            title: Text('Absensi', style: TextStyles.pBoldLight),
            onTap: () => navigate(context, 2, const PetugasAbsensiPage()),
          ),
          ExpansionTile(
            collapsedBackgroundColor: active >= 3 && active <= 5 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.bookmarks_outlined),
            title: Text('Laporan', style: TextStyles.pBoldLight),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            children: [
              ListTile(
                tileColor: active == 3 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Laporan Penjualan', style: TextStyles.pLight),
                onTap: () => navigate(context, 3, PetugasLaporanPenjualanPage()),
              ),
              ListTile(
                tileColor: active == 4 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Laporan Absensi', style: TextStyles.pLight),
                onTap: () => navigate(context, 4, PetugasLaporanAbsensiPage()),
              ),
              ListTile(
                tileColor: active == 5 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Laporan Setoran', style: TextStyles.pLight),
                onTap: () => navigate(context, 5, PetugasLaporanSetoranPage()),
              ),
            ],
          ),
          ListTile(
            tileColor: active == 6 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.account_circle_outlined, color: Colors.white),
            title: Text('Profil Pengguna', style: TextStyles.pBoldLight),
            onTap: () => navigate(context, 6, const ProfilPenggunaPage()),
          ),
          ListTile(
            tileColor: active == 7 ? Colors.white.withOpacity(0.2) : Colors.transparent,
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
                    TextButton(
                        onPressed: () async {
                          var resp = await Local.userLogout();
                          if (resp) {
                            pushAndRemoveUntil(context, const OnBoardingPage());
                          } else {
                            pop(context);
                          }
                        },
                        child: const Text('Logout')),
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
