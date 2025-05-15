import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  final Connectivity _connectivity = Connectivity();

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _initConnectivity();
    _setupConnectivityStream();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    } catch (e) {
      _isOnline = false;
      notifyListeners();
    }
  }

  void _setupConnectivityStream() {
    _connectivity.onConnectivityChanged.listen(
      (result) {
        _isOnline = result != ConnectivityResult.none;
        notifyListeners();
      },
      onError: (error) {
        _isOnline = false;
        notifyListeners();
      },
    );
  }
} 