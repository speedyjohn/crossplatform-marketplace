import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/ThemeProvider.dart';
import 'profile_header.dart';
import 'profile_user_info.dart';
import 'profile_theme_settings.dart';
import 'profile_language_settings.dart';
import 'profile_guest_view.dart';
import 'settings/password_settings.dart';
import 'settings/two_factor_settings.dart';
import 'settings/delivery_addresses.dart';
import 'settings/payment_methods.dart';
import 'settings/order_history.dart';
import 'settings/account_deletion.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final currentLanguage = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: authProvider.isLoggedIn
          ? _buildUserProfile(
              context,
              authProvider,
              isDarkMode,
              currentLanguage,
            )
          : ProfileGuestView(
              isDarkMode: isDarkMode,
              currentLanguage: currentLanguage,
              onThemeChanged: (value) {
                themeProvider.updateTheme(value);
              },
              onLanguageChanged: (value) {
                if (value != null) {
                  Provider.of<AuthProvider>(context, listen: false)
                      .updateLanguage(value);
                }
              },
            ),
    );
  }

  Widget _buildUserProfile(
    BuildContext context,
    AuthProvider authProvider,
    bool isDarkMode,
    String currentLanguage,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileUserInfo(user: authProvider.user!),
        ProfileThemeSettings(
          isDarkMode: isDarkMode,
          onThemeChanged: (value) {
            Provider.of<ThemeProvider>(context, listen: false)
                .updateTheme(value);
            if (authProvider.isLoggedIn) {
              authProvider.updateTheme(value ? 'dark' : 'light');
            }
          },
        ),
        ProfileLanguageSettings(
          currentLanguage: currentLanguage,
          onLanguageChanged: (value) {
            if (value != null) {
              authProvider.updateLanguage(value);
            }
          },
        ),
        PasswordSettings(),
        TwoFactorSettings(),
        DeliveryAddresses(),
        PaymentMethods(),
        OrderHistory(),
        AccountDeletion(),
      ],
    );
  }
}