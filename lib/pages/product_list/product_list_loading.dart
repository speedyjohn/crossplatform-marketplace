import 'package:flutter/material.dart';

class ProductListLoading extends StatelessWidget {
  final bool isInitial;

  const ProductListLoading({
    Key? key,
    this.isInitial = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isInitial ? 24 : 40,
        height: isInitial ? 24 : 40,
        child: CircularProgressIndicator(
          strokeWidth: isInitial ? 2 : 4,
          valueColor: AlwaysStoppedAnimation<Color>(
            isInitial ? Colors.black : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
} 