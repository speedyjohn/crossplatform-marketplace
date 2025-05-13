import 'package:flutter/material.dart';

class ProfileThemeSettings extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ProfileThemeSettings({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            value: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ),
      ],
    );
  }
} 