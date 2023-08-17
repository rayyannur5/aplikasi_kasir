import 'package:flutter/material.dart';

class NotVerifiedPage extends StatelessWidget {
  const NotVerifiedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/waiting.png'),
      ),
    );
  }
}
