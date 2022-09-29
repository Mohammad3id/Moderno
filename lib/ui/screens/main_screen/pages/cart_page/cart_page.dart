import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/cart_bloc.dart';
import 'package:moderno/shared_functionality/curves_with_delay.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/main_screen/pages/cart_page/widgets/cart_item_tile.dart';

class CartPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showDivider = false;

  Future<void> _updateDividerVisibility() async {
    try {
      setState(() {
        _showDivider = _scrollController.position.extentAfter > 0.0;
      });
    } catch (_) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _updateDividerVisibility(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _updateDividerVisibility(),
          );
          if (state is CartLoadFail) {
            return KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
              return AnimatedOpacity(
                opacity: isKeyboardVisible ? 0 : 1,
                curve: isKeyboardVisible
                    ? Curves.ease
                    : const CurveWithDelay(
                        delayRatio: 0.6,
                        curve: Curves.ease,
                      ),
                duration: isKeyboardVisible
                    ? const Duration(milliseconds: 200)
                    : const Duration(milliseconds: 500),
                child: Center(
                  child: Text("Error occured: ${state.errorMessage}"),
                ),
              );
            });
          } else if (state is CartLoadSuccess) {
            if (state.cartItems.isEmpty) {
              return KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                return AnimatedOpacity(
                  opacity: isKeyboardVisible ? 0 : 1,
                  curve: isKeyboardVisible
                      ? Curves.ease
                      : const CurveWithDelay(
                          delayRatio: 0.6,
                          curve: Curves.ease,
                        ),
                  duration: isKeyboardVisible
                      ? const Duration(milliseconds: 200)
                      : const Duration(milliseconds: 500),
                  child: const Center(
                    child: Text(
                      "Cart is Empty",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(100, 0, 0, 0),
                      ),
                    ),
                  ),
                );
              });
            }
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 90,
                        bottom: 10,
                      ),
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = state.cartItems[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  index == state.cartItems.length - 1 ? 0 : 20),
                          child: CartItemTile(cartItem: cartItem),
                        );
                      },
                    ),
                  ),
                ),
                CartSummary(
                  showDivider: _showDivider,
                  total: state.total,
                  totalBeforeDiscount: state.totalBeforeDiscount,
                ),
                KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease,
                    height: isKeyboardVisible ? 0 : 60,
                  );
                }),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  final int total;
  final int? totalBeforeDiscount;

  const CartSummary({
    Key? key,
    required bool showDivider,
    required this.total,
    this.totalBeforeDiscount,
  })  : _showDivider = showDivider,
        super(key: key);

  final bool _showDivider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80.5,
      child: Stack(
        children: [
          AnimatedOpacity(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 200),
            opacity: _showDivider ? 1 : 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 0.5,
              decoration: const BoxDecoration(
                color: Colors.black54,
                boxShadow: [
                  BoxShadow(offset: Offset(0, -1), blurRadius: 5),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 0.5,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        "${formatPrice(total)} EGP",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      if (totalBeforeDiscount != null)
                        Text(
                          "${formatPrice(totalBeforeDiscount!)} EGP",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text("Checkout"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
