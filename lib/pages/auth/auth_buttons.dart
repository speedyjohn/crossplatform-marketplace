import 'package:flutter/material.dart';
import 'auth_page.dart';

class AuthButtons extends StatelessWidget {
  final bool isRegistering;
  final bool isLoading;
  final VoidCallback onSubmit;

  const AuthButtons({
    Key? key,
    required this.isRegistering,
    required this.isLoading,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(isRegistering ? 'Register' : 'Login'),
          ),

        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AuthPage(isRegistering: !isRegistering),
              ),
            );
          },
          child: Text(isRegistering
              ? 'Already have an account? Login'
              : 'Need an account? Register'),
        ),
      ],
    );
  }
} 