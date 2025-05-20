import 'package:shared_preferences/shared_preferences.dart';

class PinService {
  static const String _pinKey = 'user_pin';
  final SharedPreferences _prefs;

  PinService(this._prefs);

  Future<bool> hasPin() async {
    return _prefs.containsKey(_pinKey);
  }

  Future<void> setPin(String pin) async {
    await _prefs.setString(_pinKey, pin);
  }

  Future<bool> verifyPin(String pin) async {
    final storedPin = _prefs.getString(_pinKey);
    return storedPin == pin;
  }

  Future<void> removePin() async {
    await _prefs.remove(_pinKey);
  }
} 