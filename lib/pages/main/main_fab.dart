import 'package:flutter/material.dart';
import '../profile/profile_page.dart';

class MainFAB extends StatelessWidget {
  const MainFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.person),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      tooltip: 'Login',
    );
  }
} 