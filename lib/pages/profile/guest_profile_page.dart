import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            child: Text(AppLocalizations.of(context)!.signIn),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AuthPage(isRegistering: true)),
            ),
            child: Text(AppLocalizations.of(context)!.createAccount),
          ),
        ],
      ),
    );
  }
}