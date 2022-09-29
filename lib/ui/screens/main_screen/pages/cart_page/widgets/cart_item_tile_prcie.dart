import 'package:flutter/material.dart';
import 'package:moderno/data/models/cart.dart';
import 'package:moderno/shared_functionality/format_price.dart';

class CartItemTilePrice extends StatelessWidget {
  const CartItemTilePrice({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price",
          style: TextStyle(color: Colors.green, fontSize: 10),
        ),
        const SizedBox(height: 1),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  "${formatPrice(cartItem.price)} EGP",
                  style: const TextStyle(fontSize: 20, height: 0.95),
                ),
              ),
              if (cartItem.priceBeforeDiscount != null)
                FittedBox(
                  child: Text(
                    "${formatPrice(cartItem.priceBeforeDiscount!)} EGP",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
