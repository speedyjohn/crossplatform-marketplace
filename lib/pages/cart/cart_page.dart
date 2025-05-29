import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import 'cart_item.dart';
import 'cart_empty_state.dart';
import 'cart_total.dart';
import 'cart_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _subscribeToCart();
  }

  void _subscribeToCart() {
    _cartService.getCartItems().listen((items) {
      setState(() {
        _cartItems = items;
        _totalPrice = _calculateTotal(items);
        _isLoading = false;
      });
    });
  }

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.price);
  }

  void _removeItem(int index) {
    final removedItem = _cartItems[index];
    _cartService.removeFromCart(removedItem.productId);
  }

  Future<void> _removeAllItems() async {
    await _cartService.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cartItems.isEmpty) {
      return CartEmptyState(onAddProduct: () {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cart),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Expanded(
                child: CartList(
                  listKey: _listKey,
                  cartItems: _cartItems,
                  onRemoveItem: _removeItem,
                ),
              ),
              CartTotal(
                totalPrice: _totalPrice,
                onClearCart: _removeAllItems,
              ),
            ],
          ),
        ),
      ),
    );
  }
}