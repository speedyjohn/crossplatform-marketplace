import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProducts();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showInitialLoader = false;
        });
      }
    });
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _fetchProducts();
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

  Future<List<Product>> _fetchProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
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