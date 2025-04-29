import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_list/product_list_page.dart';
import '../profile/profile_page.dart';
import '../../providers/AuthProvider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine'),
        actions: [
          if (authProvider.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
        ],
      ),
      body: const ProductListPage(),
      floatingActionButton: authProvider.isLoggedIn
          ? null
          : FloatingActionButton(
        child: const Icon(Icons.person),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
        tooltip: 'Login',
      ),
    );
  }
}