import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/cart_bloc.dart';
import 'package:moderno/shared_functionality/curves_with_delay.dart';
import 'package:moderno/ui/screens/main_screen/pages/cart_page/widgets/cart_item_tile.dart';

import 'widgets/cart_summary.dart';

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
                      "Empty Cart",
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
                CartSummary(showDivider: _showDivider),
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
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            });
          }
        },
      ),
    );
  }
}
