import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

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
          (context, animation) => _buildRemovedItem(removedProduct, animation),
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
                (context, animation) => _buildRemovedItem(removedProduct, animation),
          );
        }
      });
    }
  }

  Widget _buildRemovedItem(Product product, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: FadeTransition(
        opacity: animation,
        child: _buildCartItem(product, -1),
      ),
    );
  }

  void _navigateToDetail(Product product, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: ProductDetailPage(product: product, index: index),
          );
        },
      ),
    );
  }

  Widget _buildCartItem(Product product, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Hero(
          tag: 'cart-${product.id}-$index',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            if (product.details != null && product.details!.isNotEmpty)
              Text(
                product.details!.take(2).join(', '),
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeItem(index),
        ),
        onTap: () => _navigateToDetail(product, index),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add, size: 24),
        label: const Text('Add Product', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.green,
        ),
        onPressed: _addRandomProduct,
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          _buildAddButton(),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems() {
    return Column(
      children: [
        _buildAddButton(),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _cartProducts.length,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: _buildCartItem(_cartProducts[index], index),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                '\$${_totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!')),
              );
            },
            child: const Text('Checkout', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        actions: [
          if (_cartProducts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () async {
                await _removeAllItems();
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartProducts.isEmpty
          ? _buildEmptyCart()
          : _buildCartWithItems(),
    );
  }
}