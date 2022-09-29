import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/cart_bloc.dart';
import 'package:moderno/data/models/cart.dart';
import 'package:moderno/ui/shared_widgets/confirmation_dialog.dart';

class CartItemTileQuantityController extends StatelessWidget {
  const CartItemTileQuantityController({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FittedBox(
          child: Text(
            "Quantity",
            style: TextStyle(color: Colors.green, fontSize: 10),
          ),
        ),
        const SizedBox(height: 1),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              IconButton(
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(
                  maxHeight: 25,
                  maxWidth: 25,
                ),
                iconSize: 15,
                icon: Icon(
                  cartItem.quantity > 1 ? Icons.remove : Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (cartItem.quantity > 1) {
                    BlocProvider.of<CartBloc>(
                      context,
                      listen: false,
                    ).add(CartItemQuantityDecreased(cartItem.id));
                  } else {
                    showDialog<bool>(
                      context: context,
                      builder: (context) => const ConfirmationDialog(
                        message: "Delete item from cart?",
                        confirmButtonText: "Delete",
                        denyButtonText: "Cancel",
                      ),
                    ).then((delete) {
                      if (delete == null || !delete) {
                        return;
                      }
                      BlocProvider.of<CartBloc>(context)
                          .add(CartItemRemoved(cartItem.id));
                    });
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 25,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text("${cartItem.quantity}"),
              ),
              IconButton(
                padding: const EdgeInsets.all(5),
                constraints: const BoxConstraints(
                  maxHeight: 25,
                  maxWidth: 25,
                ),
                iconSize: 15,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  BlocProvider.of<CartBloc>(
                    context,
                    listen: false,
                  ).add(CartItemQuantityIncreased(cartItem.id));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
