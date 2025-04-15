import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<List<Product>> fetchCartProducts() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('products').get();
    final products =
    snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    products.shuffle();
    return products.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchCartProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("Cart")),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Cart")),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Cart")),
            body: const Center(child: Text("No items in cart")),
          );
        }
        final List<Product> cartProducts = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: ListView.builder(
            itemCount: cartProducts.length,
            itemBuilder: (ctx, index) {
              final product = cartProducts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toString()}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Здесь можно реализовать логику удаления товара из корзины
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} removed from cart')),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailPage(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
