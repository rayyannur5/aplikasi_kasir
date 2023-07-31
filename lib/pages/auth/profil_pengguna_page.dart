import 'package:aplikasi_kasir/api/local.dart';
import 'package:aplikasi_kasir/api/services.dart';
import 'package:aplikasi_kasir/widgets/admin_drawer.dart';
import 'package:aplikasi_kasir/widgets/petugas_drawer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilPenggunaPage extends StatelessWidget {
  const ProfilPenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      drawer: FutureBuilder(
          future: Local.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox();
            if (snapshot.data!['user_role'] == 'admin') {
              return DrawerAdmin(size: size, active: 12);
            }
            return DrawerPetugas(size: size, active: 6);
          }),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
            future: Services.getUserInformation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: LottieBuilder.asset('assets/lotties/loading.json'));
              var data = snapshot.data!;
              return Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: data['nama']),
                    decoration: InputDecoration(
                        labelText: 'Nama',
                        suffixIcon: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: TextEditingController(text: data['nama']),
                                        decoration: const InputDecoration(labelText: 'Nama'),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(onPressed: () {}, child: const Text('Simpan')),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit))),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: data['role']),
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: data['email']),
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: data['phone']),
                    decoration: const InputDecoration(labelText: 'No Telp'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: "*****"),
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      const TextField(
                                        // controller: TextEditingController(text: data['nama']),
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Password Lama'),
                                      ),
                                      const SizedBox(height: 20),
                                      const TextField(
                                        // controller: TextEditingController(text: data['nama']),
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Password Baru'),
                                      ),
                                      const SizedBox(height: 20),
                                      const TextField(
                                        // controller: TextEditingController(text: data['nama']),
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Ketik Ulang Password Baru'),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(onPressed: () {}, child: const Text('Simpan')),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit))),
                  ),
                  const Spacer(),
                  ElevatedButton(onPressed: () {}, child: const Text('Logout')),
                ],
              );
            }),
      ),
    );
  }
}
