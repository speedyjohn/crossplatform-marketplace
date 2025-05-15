import 'package:flutter/material.dart';

class UserSessionProvider with ChangeNotifier {
  String _name = 'Гость';
  String _email = 'guest@example.com';
  List<String> _addresses = [];
  List<String> _paymentMethods = [];

  String get name => _name;
  String get email => _email;
  List<String> get addresses => List.unmodifiable(_addresses);
  List<String> get paymentMethods => List.unmodifiable(_paymentMethods);

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  void addAddress(String address) {
    _addresses.add(address);
    notifyListeners();
  }

  void removeAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _addresses.removeAt(index);
      notifyListeners();
    }
  }

  void addPaymentMethod(String method) {
    _paymentMethods.add(method);
    notifyListeners();
  }

  void removePaymentMethod(int index) {
    if (index >= 0 && index < _paymentMethods.length) {
      _paymentMethods.removeAt(index);
      notifyListeners();
    }
  }
} 