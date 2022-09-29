import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/ui/screens/product_screen/product_screen.dart';

class CartItemTileImage extends StatelessWidget {
  const CartItemTileImage({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
