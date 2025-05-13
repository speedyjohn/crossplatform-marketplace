import 'package:flutter/material.dart';

class AuthErrorMessage extends StatelessWidget {
  final String message;

  const AuthErrorMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
} 