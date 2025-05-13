import 'package:flutter/material.dart';

class SettingsThemeCard extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const SettingsThemeCard({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Visual',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Dark Theme'),
              value: isDarkMode,
              onChanged: onThemeChanged,
              secondary: Icon(
                isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                color: isDarkMode ? Colors.blueAccent : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 