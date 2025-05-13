import 'package:flutter/material.dart';

class ProductListEmpty extends StatelessWidget {
  const ProductListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No products available',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
} 