import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/AuthProvider.dart';
import 'auth_error_message.dart';
import 'auth_text_fields.dart';
import 'auth_buttons.dart';

class AuthForm extends StatefulWidget {
  final bool isRegistering;

  const AuthForm({
    Key? key,
    required this.isRegistering,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      String? error;

      if (widget.isRegistering) {
        error = await authProvider.register(
          email: email,
          password: password,
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
        );
      } else {
        error = await authProvider.login(email, password);
      }

      if (error != null) {
        setState(() => _errorMessage = error);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_errorMessage != null)
            AuthErrorMessage(message: _errorMessage!),

          AuthTextFields(
            isRegistering: widget.isRegistering,
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            phoneController: _phoneController,
            addressController: _addressController,
          ),

          const SizedBox(height: 20),

          AuthButtons(
            isRegistering: widget.isRegistering,
            isLoading: _isLoading,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }
} 