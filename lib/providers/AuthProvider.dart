import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/AuthService.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  AppUser? _user;
  bool _isGuest = true;
  ThemeMode _themeMode = ThemeMode.light;
  String _currentTheme = 'light';
  Locale _locale = const Locale('en');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthProvider(this._authService) {
    _authService.user.listen((user) {
      _user = user;
      if (user != null) {
        _themeMode = user.theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
        _locale = Locale(user.language);
      }
      notifyListeners();
    });
  }

  String get currentTheme => _currentTheme;
  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isGuest => !isLoggedIn && _isGuest;

  Future<void> initialize() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _user = await _getUserData(user.uid);
        _isGuest = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      _isGuest = true;
      notifyListeners();
    }
  }

  Future<void> _updateAuthState(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _isGuest = true;
    } else {
      _user = await _getUserData(firebaseUser.uid);
      _isGuest = false;
    }
    notifyListeners();
  }

  Future<AppUser?> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  Future<void> loginAsGuest() async {
    _isGuest = true;
    notifyListeners();
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    String? address,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = AppUser(
        uid: credential.user!.uid,
        email: email,
        name: name,
        address: address,
        phone: phone,
      );

      await _firestore.collection('users').doc(_user!.uid).set(_user!.toFirestore());
      await _updateAuthState(credential.user);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registration failed';
    } catch (e) {
      return 'Unknown error occurred';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateAuthState(credential.user);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    } catch (e) {
      return 'Unknown error occurred';
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      _isGuest = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  Future<void> updateTheme(String theme) async {
    if (_currentTheme == theme) return;

    _currentTheme = theme;
    _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();

    try {
      if (_user != null) {
        await _authService.updateUserPreferences(_user!.uid, theme: theme);
      }
    } catch (e) {
      _currentTheme = theme == 'dark' ? 'light' : 'dark';
      _themeMode = _currentTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
      debugPrint('Failed to update theme: $e');
    }
  }

  Future<void> updateLanguage(String language) async {
    if (_user == null) return;
    _locale = Locale(language);
    await _authService.updateUserPreferences(_user!.uid, language: language);
    notifyListeners();
  }
}