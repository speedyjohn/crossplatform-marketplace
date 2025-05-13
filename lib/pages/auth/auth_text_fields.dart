import 'package:flutter/material.dart';

class AuthTextFields extends StatelessWidget {
  final bool isRegistering;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const AuthTextFields({
    Key? key,
    required this.isRegistering,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),

        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),

        if (isRegistering) ...[
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),

          TextFormField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
        ],
      ],
    );
  }
} 