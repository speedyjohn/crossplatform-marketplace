import 'package:flutter/material.dart';
import '../auth/auth_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: Text(AppLocalizations.of(context)!.profile),
      actions: [
        if (isLoggedIn)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              onLogout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.loggedOutSuccessfully),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context)!.signIn,
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