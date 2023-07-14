import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/navigator.dart';
import '../utils/textstyles.dart';

class PetugasDrawer extends StatelessWidget {
  const PetugasDrawer({
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
            leading: const Icon(Icons.local_mall_outlined, color: Colors.white),
            title: Text('Katalog', style: TextStyles.pBoldLight),
            onTap: () {},
          ),
          ListTile(
            tileColor: active == 2 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.qr_code_scanner, color: Colors.white),
            title: Text('Absensi', style: TextStyles.pBoldLight),
            onTap: () {},
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
                onTap: () {},
              ),
              ListTile(
                tileColor: active == 4 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Laporan Absensi', style: TextStyles.pLight),
                onTap: () {},
              ),
              ListTile(
                tileColor: active == 5 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                title: Text('Laporan Setoran', style: TextStyles.pLight),
                onTap: () {},
              ),
            ],
          ),
          ListTile(
            tileColor: active == 6 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.account_circle_outlined, color: Colors.white),
            title: Text('Profil Pengguna', style: TextStyles.pBoldLight),
            onTap: () {},
          ),
          ListTile(
            tileColor: active == 7 ? Colors.white.withOpacity(0.2) : Colors.transparent,
            leading: const Icon(Icons.logout_outlined, color: Colors.white),
            title: Text('Logout', style: TextStyles.pBoldLight),
            onTap: () {
              pop(context);
              showCupertinoDialog(
                context: context,
                builder: (context) => AlertDialog(actions: [TextButton(onPressed: () {}, child: const Text('Logout')), TextButton(onPressed: () {}, child: const Text('Batal'))]),
              );
            },
          ),
        ],
      ),
    );
  }
}
