import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/calculate_color_value.dart';
import 'package:moderno/shared_functionality/calculate_contrast.dart';
import 'package:moderno/shared_functionality/format_enum.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/product_screen/product_screen.dart';

class OrderItemTile extends StatelessWidget {
  final CartItem cartItem;

  const OrderItemTile({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: Color.fromARGB(0, 0, 0, 0),
                ),
              );
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => ProductScreen(
                    productId: cartItem.product.id,
                    mainImageUrl: cartItem.product.imagesUrls.first,
                    heroTag: cartItem.id,
                    startingAttributes: cartItem.productAttributes,
                    isBundle: cartItem.product is Bundle,
                  ),
                ),
              )
                  .then(
                (_) {
                  SystemChrome.setSystemUIOverlayStyle(
                    const SystemUiOverlayStyle(
                      statusBarColor: Color.fromARGB(128, 0, 0, 0),
                    ),
                  );
                },
              );
            },
            child: Hero(
              tag: cartItem.id,
              child: Container(
                width: 100,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(100, 0, 0, 0),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  cartItem.product.imagesUrls.first,
                  fit: BoxFit.cover,
                  height: 0,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name and Stock Status
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formateEnum(cartItem.product.stockStatus),
                      style: TextStyle(
                        fontSize: 10,
                        color: cartItem.product.stockStatus ==
                                ProductStockStatus.inStock
                            ? Colors.green
                            : cartItem.product.stockStatus ==
                                    ProductStockStatus.inStockSoon
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
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Column(
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
                                color:
                                    Color(calculateColorValue(attributeValue)),
                                borderRadius: BorderRadius.circular(20),
                                border: calculateContrast(
                                            attributeValue, "#FFFFFF") <
                                        50
                                    ? Border.all(
                                        color: Theme.of(context).primaryColor,
                                        strokeAlign: StrokeAlign.inside,
                                      )
                                    : null,
                              ),
                            );
                          } else {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 25,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "${formatPrice(cartItem.price)} EGP",
                          style: const TextStyle(fontSize: 20, height: 0.95),
                        ),
                        if (cartItem.priceBeforeDiscount != null)
                          Text(
                            "${formatPrice(cartItem.priceBeforeDiscount!)} EGP",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          "${cartItem.quantity} Units",
                          style: const TextStyle(fontSize: 20, height: 0.95),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
