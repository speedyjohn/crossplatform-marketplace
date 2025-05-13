import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_list/product_list_page.dart';
import '../../providers/AuthProvider.dart';
import 'main_app_bar.dart';
import 'main_fab.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: const MainAppBar(),
      body: const ProductListPage(),
      floatingActionButton: authProvider.isLoggedIn ? null : const MainFAB(),
    );
  }
}