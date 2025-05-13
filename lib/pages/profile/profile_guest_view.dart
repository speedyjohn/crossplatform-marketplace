import 'package:flutter/material.dart';
import '../auth/auth_page.dart';
import 'profile_theme_settings.dart';
import 'profile_language_settings.dart';

class ProfileGuestView extends StatelessWidget {
  final bool isDarkMode;
  final String currentLanguage;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String?> onLanguageChanged;

  const ProfileGuestView({
    Key? key,
    required this.isDarkMode,
    required this.currentLanguage,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              const Icon(Icons.person_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'You are in guest mode',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to access full profile features',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthPage()),
                  );
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Guest Settings',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ProfileThemeSettings(
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
        ),
        ProfileLanguageSettings(
          currentLanguage: currentLanguage,
          onLanguageChanged: onLanguageChanged,
        ),
      ],
    );
  }
} 