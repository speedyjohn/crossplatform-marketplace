import 'package:flutter/material.dart';
import '../custom_page_route.dart';
import '../main.dart'; // чтобы получить доступ к MainNavigationPage

class WelcomePage extends StatelessWidget {
  final String userName;
  const WelcomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(CustomPageRoute(
        child: const MainNavigationPage(),
        direction: AxisDirection.down,
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
