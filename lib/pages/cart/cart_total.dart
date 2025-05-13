import 'package:flutter/material.dart';

class CartTotal extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onClearCart;

  const CartTotal({
    Key? key,
    required this.totalPrice,
    required this.onClearCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            children: [
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: onClearCart,
                tooltip: 'Clear cart',
              ),
            ],
          ),
        ],
      ),
    );
  }
} 