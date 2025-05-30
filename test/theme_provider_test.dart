import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:market/providers/ThemeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

@GenerateMocks([SharedPreferences])
import 'theme_provider_test.mocks.dart';

void main() {
  late MockSharedPreferences mockPrefs;
  late ThemeProvider themeProvider;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(mockPrefs.getBool('darkMode')).thenAnswer((_) async => false);
    themeProvider = ThemeProvider(mockPrefs);
  });

  group('ThemeProvider Tests', () {
    test('Initial theme should be light', () {
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('updateTheme should change theme mode', () async {
      when(mockPrefs.setBool('darkMode', true)).thenAnswer((_) async => true);
      await themeProvider.updateTheme(true); // true for dark mode
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('updateTheme should save preference', () async {
      when(mockPrefs.setBool('darkMode', true)).thenAnswer((_) async => true);
      
      await themeProvider.updateTheme(true);
      
      verify(mockPrefs.setBool('darkMode', true)).called(1);
    });
  });
} 