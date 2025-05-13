import 'package:flutter/material.dart';

class DeliveryAddresses extends StatelessWidget {
  const DeliveryAddresses({Key? key}) : super(key: key);

  void _showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Address Name (e.g. Home, Work)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Street Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Postal Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
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
            child: const Text('Add Address'),
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
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Delivery Addresses'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddAddressDialog(context),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Home'),
            subtitle: const Text('123 Main St, Apt 4B\nNew York, NY 10001'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Set as Default'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Work'),
            subtitle: const Text('456 Business Ave\nNew York, NY 10002'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Set as Default'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 