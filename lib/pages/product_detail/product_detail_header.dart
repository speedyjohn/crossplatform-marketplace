import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'full_screen_image.dart';

class ProductDetailHeader extends StatelessWidget {
  final Product product;
  final int index;

  const ProductDetailHeader({
    Key? key,
    required this.product,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FullScreenImage(
            imageUrl: product.imageUrl,
            heroTag: 'product-${product.id}-$index',
          ),
        ),
      ),
      child: Hero(
        tag: 'product-${product.id}-$index',
        child: Image.network(
          product.imageUrl,
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 300,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 50),
          ),
        ),
      ),
    );
  }
} 