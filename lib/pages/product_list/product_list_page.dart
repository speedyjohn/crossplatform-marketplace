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

  Widget _buildHeader(bool isOnline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          if (isOnline)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProducts,
              tooltip: 'Обновить список',
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 18,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'You are offline',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showInitialLoader) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: ProductListLoading(isInitial: true),
      );
    }

    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        return Scaffold(
          body: Column(
            children: [
              _buildHeader(connectivity.isOnline),
              Expanded(
                child: _hasError
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
              ),
            ],
          ),
        );
      },
    );
  }
}

