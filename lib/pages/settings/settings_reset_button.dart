import 'package:flutter/material.dart';

class SettingsResetButton extends StatelessWidget {
  final VoidCallback onReset;

  const SettingsResetButton({
    Key? key,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.restore),
      label: const Text('Reset settings'),
      onPressed: onReset,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
} 