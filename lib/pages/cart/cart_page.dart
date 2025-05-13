import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';
import 'cart_item.dart';
import 'cart_empty_state.dart';
import 'cart_total.dart';
import 'cart_list.dart';
import 'cart_add_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Product> _cartProducts = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartProducts();
  }

  Future<void> _loadCartProducts() async {
    final products = await _fetchCartProducts();
    setState(() {
      _cartProducts = products;
      _totalPrice = _calculateTotal(products);
      _isLoading = false;
    });
  }

  Future<List<Product>> _fetchCartProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').limit(5).get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<Product> _fetchRandomProduct() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    final allProducts =
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    allProducts.shuffle();
    return allProducts.first;
  }

  double _calculateTotal(List<Product> products) {
    return products.fold(0, (sum, product) => sum + product.price);
  }

  void _addRandomProduct() async {
    final randomProduct = await _fetchRandomProduct();
    setState(() {
      _cartProducts.insert(0, randomProduct);
      _totalPrice += randomProduct.price;
    });
    _listKey.currentState?.insertItem(0,
        duration: const Duration(milliseconds: 300));
  }

  void _removeItem(int index) {
    final removedProduct = _cartProducts[index];
    setState(() {
      _totalPrice -= removedProduct.price;
      _cartProducts.removeAt(index);
    });

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => CartItem(
        product: removedProduct,
        index: -1,
        onRemove: (_) {},
      ),
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _removeAllItems() async {
    for (var i = _cartProducts.length - 1; i >= 0; i--) {
      final removedProduct = _cartProducts[i];
      await Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _totalPrice -= removedProduct.price;
            _cartProducts.removeAt(i);
          });
          _listKey.currentState?.removeItem(
            i,
            (context, animation) => CartItem(
              product: removedProduct,
              index: -1,
              onRemove: (_) {},
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cartProducts.isEmpty) {
      return CartEmptyState(onAddProduct: _addRandomProduct);
    }

    return Scaffold(
      body: Column(
        children: [
          CartAddButton(onPressed: _addRandomProduct),
          Expanded(
            child: CartList(
              listKey: _listKey,
              products: _cartProducts,
              onRemoveItem: _removeItem,
            ),
          ),
          CartTotal(
            totalPrice: _totalPrice,
            onClearCart: _removeAllItems,
          ),
        ],
      ),
    );
  }
}