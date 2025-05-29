import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;
  final VoidCallback? onAdded;

  const AddToCartButton({
    Key? key,
    required this.product,
    this.onAdded,
  }) : super(key: key);

  Future<void> _addToCart(BuildContext context) async {
    final cartService = CartService();
    await cartService.addToCart(product);
    if (onAdded != null) {
      onAdded!();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.cartProductAdded),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _addToCart(context),
      icon: const Icon(Icons.shopping_cart),
      label: Text(AppLocalizations.of(context)!.cartAdd),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 