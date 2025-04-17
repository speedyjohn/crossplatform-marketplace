import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'product_detail_page.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Product> _cartProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartProducts();
  }

  Future<void> _loadCartProducts() async {
    final products = await fetchCartProducts();
    setState(() {
      _cartProducts = products;
      _isLoading = false;
    });
  }

  Future<List<Product>> fetchCartProducts() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('products').get();
    final products =
    snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    products.shuffle();
    return products.take(5).toList();
  }

  void _removeItem(int index) {
    final removedItem = _cartProducts[index];
    _cartProducts.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
          (context, animation) => _buildItem(removedItem, animation, index),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildItem(
      Product product, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: Image.network(
            product.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
          ),
          title: Text(product.name),
          subtitle: Text('\$${product.price.toString()}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeItem(index),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_cartProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: const Center(child: Text('No items in cart')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _cartProducts.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_cartProducts[index], animation, index);
        },
      ),
    );
  }
}

// Note: ensure to import ProductDetailPage
