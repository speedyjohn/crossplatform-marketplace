import 'package:flutter/material.dart';
import '../services/pin_service.dart';

class PinProvider extends ChangeNotifier {
  final PinService _pinService;
  bool _isAuthenticated = false;
  bool _isInitialized = false;

  PinProvider(this._pinService);

  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> hasPin() async {
    return _pinService.hasPin();
  }

  Future<void> setPin(String pin) async {
    await _pinService.setPin(pin);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    final isValid = await _pinService.verifyPin(pin);
    if (isValid) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return isValid;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
} 