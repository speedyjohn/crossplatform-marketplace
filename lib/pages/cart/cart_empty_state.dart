import 'package:flutter/material.dart';
import 'cart_add_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartEmptyState extends StatelessWidget {
  final VoidCallback onAddProduct;

  const CartEmptyState({
    Key? key,
    required this.onAddProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.cartEmpty,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(AppLocalizations.of(context)!.browseProducts),
          ),
        ],
      ),
    );
  }
} 