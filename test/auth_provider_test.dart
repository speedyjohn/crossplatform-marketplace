import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:market/providers/AuthProvider.dart' as app;
import 'package:market/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

@GenerateMocks([AuthService, firebase.FirebaseAuth, FirebaseFirestore, firebase.User, SharedPreferences])
import 'auth_provider_test.mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockSharedPreferences mockPrefs;
  late app.AuthProvider authProvider;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseAuthMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    mockAuthService = MockAuthService();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockPrefs = MockSharedPreferences();
    authProvider = app.AuthProvider(mockAuthService);
  });

  group('AuthProvider Tests', () {
    test('Initial state should be guest', () {
      expect(authProvider.isGuest, true);
      expect(authProvider.isLoggedIn, false);
      expect(authProvider.user, null);
    });

    test('loginAsGuest should set isGuest to true', () async {
      await authProvider.loginAsGuest();
      expect(authProvider.isGuest, true);
    });

    test('updateTheme should update theme mode', () async {
      await authProvider.updateTheme('dark');
      expect(authProvider.themeMode, ThemeMode.dark);
      expect(authProvider.currentTheme, 'dark');
    });

    test('updateLanguage should update locale', () async {
      await authProvider.updateLanguage('ru');
      expect(authProvider.locale.languageCode, 'ru');
    });
  });
}

void setupFirebaseAuthMocks([MockFirebaseAuth? mockAuth]) {
  TestWidgetsFlutterBinding.ensureInitialized();
} 