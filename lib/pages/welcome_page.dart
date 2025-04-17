import 'package:flutter/material.dart';
import '../main.dart'; // чтобы получить доступ к MainNavigationPage

class WelcomePage extends StatelessWidget {
  final String userName;
  const WelcomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // После 2 секунд автоматический переход
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainNavigationPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ));
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome, $userName!',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
