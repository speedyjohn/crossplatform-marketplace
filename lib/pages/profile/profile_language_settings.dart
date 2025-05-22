import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileLanguageSettings extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String?> onLanguageChanged;

  const ProfileLanguageSettings({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'kk':
        return 'Қазақша';
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.settings,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.appLanguage),
          trailing: DropdownButton<String>(
            value: currentLanguage,
            items: [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'ru', child: Text('Русский')),
              DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
            ],
            onChanged: onLanguageChanged,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
} 