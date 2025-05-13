import 'package:flutter/material.dart';

class TwoFactorSettings extends StatefulWidget {
  const TwoFactorSettings({Key? key}) : super(key: key);

  @override
  State<TwoFactorSettings> createState() => _TwoFactorSettingsState();
}

class _TwoFactorSettingsState extends State<TwoFactorSettings> {
  bool _isTwoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.security),
            title: const Text('Two-Factor Authentication'),
            subtitle: Text(
              _isTwoFactorEnabled
                  ? 'Enabled - Using Authenticator App'
                  : 'Disabled - Enable for extra security',
            ),
            value: _isTwoFactorEnabled,
            onChanged: (value) {
              if (value) {
                // Show setup dialog when enabling
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Setup 2FA'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/220px-QR_code_for_mobile_English_Wikipedia.svg.png',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 16),
                        const Text('Scan this QR code with your authenticator app'),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Enter verification code',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => _isTwoFactorEnabled = true);
                        },
                        child: const Text('Enable 2FA'),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() => _isTwoFactorEnabled = false);
              }
            },
          ),
          if (_isTwoFactorEnabled)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('View Backup Codes'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Change App'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 