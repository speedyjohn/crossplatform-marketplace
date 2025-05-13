import 'package:flutter/material.dart';

class AccountDeletion extends StatelessWidget {
  const AccountDeletion({Key? key}) : super(key: key);

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Type "DELETE" to confirm',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.warning_outlined, color: Colors.red),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text(
              'Permanently delete your account and all data',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () => _showDeleteAccountDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.pause_circle_outline, color: Colors.orange),
            title: const Text(
              'Deactivate Account',
              style: TextStyle(color: Colors.orange),
            ),
            subtitle: const Text(
              'Temporarily disable your account',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // Show deactivate account dialog
            },
          ),
        ],
      ),
    );
  }
} 