import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'cart_item.dart';

class CartList extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey;
  final List<Product> products;
  final Function(int) onRemoveItem;

  const CartList({
    Key? key,
    required this.listKey,
    required this.products,
    required this.onRemoveItem,
  }) : super(key: key);

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
        child: CartItem(
          product: product,
          index: -1,
          onRemove: (_) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: products.length,
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
            child: CartItem(
              product: products[index],
              index: index,
              onRemove: onRemoveItem,
            ),
          ),
        );
      },
    );
  }
} 