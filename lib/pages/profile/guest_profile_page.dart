import 'package:flutter/material.dart';

import '../auth/auth_page.dart';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Profile features are available only for registered users',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AuthPage()),
            ),
            child: const Text('Sign In'),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AuthPage(isRegistering: true)),
            ),
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }
}