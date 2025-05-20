import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionProvider with ChangeNotifier {
  String _name = 'Guest';
  String _email = 'guest@example.com';
  List<String> _addresses = [];
  List<String> _paymentMethods = [];
  final SharedPreferences _prefs;

  UserSessionProvider(this._prefs) {
    _loadData();
  }

  String get name => _name;
  String get email => _email;
  List<String> get addresses => List.unmodifiable(_addresses);
  List<String> get paymentMethods => List.unmodifiable(_paymentMethods);

  Future<void> _loadData() async {
    _name = _prefs.getString('user_name') ?? 'Guest';
    _email = _prefs.getString('user_email') ?? 'guest@example.com';
    _addresses = _prefs.getStringList('user_addresses') ?? [];
    _paymentMethods = _prefs.getStringList('user_payment_methods') ?? [];
    notifyListeners();
  }

  Future<void> _saveData() async {
    await _prefs.setString('user_name', _name);
    await _prefs.setString('user_email', _email);
    await _prefs.setStringList('user_addresses', _addresses);
    await _prefs.setStringList('user_payment_methods', _paymentMethods);
  }

  void updateName(String newName) {
    _name = newName;
    _saveData();
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    _saveData();
    notifyListeners();
  }

  void addAddress(String address) {
    _addresses.add(address);
    _saveData();
    notifyListeners();
  }

  void removeAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _addresses.removeAt(index);
      _saveData();
      notifyListeners();
    }
  }

  void addPaymentMethod(String method) {
    _paymentMethods.add(method);
    _saveData();
    notifyListeners();
  }

  void removePaymentMethod(int index) {
    if (index >= 0 && index < _paymentMethods.length) {
      _paymentMethods.removeAt(index);
      _saveData();
      notifyListeners();
    }
  }

  void clearData() {
    _name = 'Guest';
    _email = 'guest@example.com';
    _addresses = [];
    _paymentMethods = [];
    _saveData();
    notifyListeners();
  }
} 