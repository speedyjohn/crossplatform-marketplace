import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/ThemeProvider.dart';
import '../auth/auth_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (authProvider.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authProvider.logout();
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
      ),
      body: authProvider.isLoggedIn
          ? _buildUserProfile(context, authProvider, themeProvider)
          : _buildGuestProfile(context),
    );
  }

  Widget _buildUserProfile(
      BuildContext context,
      AuthProvider authProvider,
      ThemeProvider themeProvider,
      ) {
    final user = authProvider.user!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Информация о пользователе
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Email'),
          subtitle: Text(user.email),
        ),
        if (user.name != null) ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Name'),
          subtitle: Text(user.name!),
        ),

        // Настройки темы
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_4),
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.updateTheme(value ? true : false);
              if (authProvider.isLoggedIn) {
                authProvider.updateTheme(value ? 'dark' : 'light');
              }
            },
          ),
        ),

        // Настройки языка
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Language',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('App Language'),
          trailing: DropdownButton<String>(
            value: Localizations.localeOf(context).languageCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ru', child: Text('Русский')),
              DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
            ],
            onChanged: (value) {
              if (value != null) {
                authProvider.updateLanguage(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Гостевое сообщение
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

        // Базовые настройки для гостей
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Guest Settings',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_4),
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.updateTheme(value ? true : false);
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('App Language'),
          trailing: DropdownButton<String>(
            value: Localizations.localeOf(context).languageCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ru', child: Text('Русский')),
              DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
            ],
            onChanged: (value) {
              if (value != null) {
                // Для гостей сохраняем только локально
                Provider.of<AuthProvider>(context, listen: false)
                    .updateLanguage(value);
              }
            },
          ),
        ),
      ],
    );
  }
}