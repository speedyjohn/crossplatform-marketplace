import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import 'cart_item.dart';

class CartList extends StatelessWidget {
  final GlobalKey<AnimatedListState> listKey;
  final List<CartItem> cartItems;
  final Function(int) onRemoveItem;

  const CartList({
    Key? key,
    required this.listKey,
    required this.cartItems,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: cartItems.length,
      itemBuilder: (context, index, animation) {
        final item = cartItems[index];
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: CartItemWidget(
            cartItem: item,
            index: index,
            onRemove: onRemoveItem,
          ),
        );
      },
    );
  }
} 