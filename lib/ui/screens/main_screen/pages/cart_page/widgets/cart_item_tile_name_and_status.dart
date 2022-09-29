import 'package:flutter/material.dart';
import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/format_enum.dart';

class CartItemTileNameAndStatus extends StatelessWidget {
  const CartItemTileNameAndStatus({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formateEnum(cartItem.product.stockStatus),
          style: TextStyle(
            fontSize: 10,
            color: cartItem.product.stockStatus == ProductStockStatus.inStock
                ? Colors.green
                : cartItem.product.stockStatus == ProductStockStatus.inStockSoon
                    ? Colors.blue
                    : Colors.red,
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                cartItem.product.name,
                style: const TextStyle(fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (cartItem.product is Bundle)
              Container(
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Bundle",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
