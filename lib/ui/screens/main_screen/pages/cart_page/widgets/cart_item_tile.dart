import 'package:flutter/material.dart';
import 'package:moderno/data/models/cart.dart';

import 'cart_item_tile_attributes.dart';
import 'cart_item_tile_image.dart';
import 'cart_item_tile_name_and_status.dart';
import 'cart_item_tile_prcie.dart';
import 'cart_item_tile_quantity_controller.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CartItemTileImage(cartItem: cartItem),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CartItemTileNameAndStatus(cartItem: cartItem),
                const SizedBox(height: 5),
                CartItemTileAttributes(cartItem: cartItem),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CartItemTileQuantityController(cartItem: cartItem),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CartItemTilePrice(cartItem: cartItem),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
