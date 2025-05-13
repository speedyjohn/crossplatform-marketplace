import 'package:flutter/material.dart';
import 'auth_form.dart';

class AuthPage extends StatelessWidget {
  final bool isRegistering;

  const AuthPage({
    Key? key,
    this.isRegistering = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegistering ? 'Register' : 'Login'),
      ),
      body: AuthForm(isRegistering: isRegistering),
    );
  }
}