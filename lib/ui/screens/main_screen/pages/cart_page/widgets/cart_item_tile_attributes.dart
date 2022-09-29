import 'package:flutter/material.dart';
import 'package:moderno/data/models/cart.dart';
import 'package:moderno/shared_functionality/calculate_color_value.dart';

class CartItemTileAttributes extends StatelessWidget {
  const CartItemTileAttributes({
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
          "Attributes",
          style: TextStyle(color: Colors.green, fontSize: 10),
        ),
        const SizedBox(height: 1),
        Wrap(
          runSpacing: 5,
          spacing: 5,
          children: cartItem.productAttributes.entries.map(
            (entry) {
              final attributeLabel = entry.key;
              final attributeValue = entry.value;
              if (attributeLabel.toLowerCase() == "color") {
                return Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Color(calculateColorValue(attributeValue)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        attributeValue,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              }
            },
          ).toList(),
        ),
      ],
    );
  }
}
