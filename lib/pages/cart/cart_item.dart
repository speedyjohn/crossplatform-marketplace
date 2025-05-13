import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../product_detail/product_detail_page.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final int index;
  final Function(int) onRemove;

  const CartItem({
    Key? key,
    required this.product,
    required this.index,
    required this.onRemove,
  }) : super(key: key);

  void _navigateToDetail(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => onRemove(index),
        ),
        onTap: () => _navigateToDetail(context),
      ),
    );
  }
} 