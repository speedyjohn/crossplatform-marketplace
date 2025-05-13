import 'package:flutter/material.dart';
import '../auth/auth_page.dart';

class ProfileHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final VoidCallback onLogout;

  const ProfileHeader({
    Key? key,
    required this.isLoggedIn,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Profile'),
      actions: [
        if (isLoggedIn)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              onLogout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Logged out successfully'),
                  action: SnackBarAction(
                    label: 'Sign In',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                      );
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 