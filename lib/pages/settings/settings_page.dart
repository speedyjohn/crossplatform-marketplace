import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../providers/ThemeProvider.dart';
import 'settings_theme_card.dart';
import 'settings_language_card.dart';
import 'settings_reset_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'Русский';
  final List<String> _languages = ['Русский', 'English', 'Қазақша'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'Русский';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setString('language', _selectedLanguage);
  }

  void _updateTheme(bool value) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    provider.updateTheme(value);
    setState(() {
      _isDarkMode = value;
    });
    _saveSettings();
  }

  void _updateLanguage(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedLanguage = newValue;
      });
      _saveSettings();
    }
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    provider.updateTheme(false);
    setState(() {
      _isDarkMode = false;
      _selectedLanguage = 'Русский';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SettingsThemeCard(
              isDarkMode: _isDarkMode,
              onThemeChanged: _updateTheme,
            ),
            const SizedBox(height: 20),
            SettingsLanguageCard(
              selectedLanguage: _selectedLanguage,
              languages: _languages,
              onLanguageChanged: _updateLanguage,
            ),
            const SizedBox(height: 30),
            SettingsResetButton(onReset: _resetSettings),
          ],
        ),
      ),
    );
  }
}
