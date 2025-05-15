import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';
import '../../services/product_storage_service.dart';
import '../../providers/connectivity_provider.dart';
import 'product_list_item.dart';
import 'product_list_error.dart';
import 'product_list_loading.dart';
import 'product_list_empty.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> _products = [];
  bool _isLoading = true;
  bool _showInitialLoader = true;
  bool _hasError = false;
  late final ProductStorageService _productService;

  @override
  void initState() {
    super.initState();
    _initProductService();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showInitialLoader = false;
        });
      }
    });
  }

  Future<void> _initProductService() async {
    final prefs = await SharedPreferences.getInstance();
    _productService = ProductStorageService(prefs: prefs);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showInitialLoader) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: ProductListLoading(isInitial: true),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Consumer<ConnectivityProvider>(
            builder: (context, connectivity, _) {
              if (!connectivity.isOnline) {
                return Container(
                  width: double.infinity,
                  color: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: const Text(
                    'Offline Mode - Showing Cached Data',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      body: _hasError
          ? ProductListError(onRetry: _loadProducts)
          : _isLoading
              ? const ProductListLoading()
              : _products.isEmpty
                  ? const ProductListEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return ProductListItem(
                          product: _products[index],
                          index: index,
                        );
                      },
                    ),
    );
  }
}