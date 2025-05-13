import 'package:flutter/material.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Order History'),
            trailing: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // Show filter options
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Order #1234'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('3 items • \$156.00'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Delivered',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            trailing: const Text('Today'),
            onTap: () {
              // Show order details
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Order #1233'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1 item • \$49.99'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'In Transit',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            trailing: const Text('Yesterday'),
            onTap: () {
              // Show order details
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Order #1232'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('2 items • \$98.50'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Processing',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            trailing: const Text('2 days ago'),
            onTap: () {
              // Show order details
            },
          ),
        ],
      ),
    );
  }
} 