import 'package:flutter/material.dart';

class ProductRating extends StatelessWidget {
  final double rating;
  final double size;

  const ProductRating({
    Key? key,
    required this.rating,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
} 