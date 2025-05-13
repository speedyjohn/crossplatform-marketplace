import 'package:flutter/material.dart';

class ProfileLanguageSettings extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String?> onLanguageChanged;

  const ProfileLanguageSettings({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageChanged,
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
            'Language',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('App Language'),
          trailing: DropdownButton<String>(
            value: currentLanguage,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ru', child: Text('Русский')),
              DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
            ],
            onChanged: onLanguageChanged,
          ),
        ),
      ],
    );
  }
} 