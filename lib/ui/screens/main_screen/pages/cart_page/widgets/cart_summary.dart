import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/cart_bloc.dart';
import 'package:moderno/bloc/global_bloc.dart';
import 'package:moderno/data/repositories/user_repository.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/shared_widgets/confirmation_dialog.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    Key? key,
    required bool showDivider,
  })  : _showDivider = showDivider,
        super(key: key);

  final bool _showDivider;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is! CartLoadSuccess) {
          return const Center(
            child: Text("Error"),
          );
        }
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
                            "${formatPrice(state.total)} EGP",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          if (state.totalBeforeDiscount != null)
                            Text(
                              "${formatPrice(state.totalBeforeDiscount!)} EGP",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      RepositoryProvider.value(
                        value: UserRepository.instance,
                        child: Builder(builder: (context) {
                          return TextButton(
                            onPressed: () async {
                              RepositoryProvider.of<UserRepository>(
                                context,
                              ).isUserLogedIn().then(
                                (isLogednIn) {
                                  if (isLogednIn) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const ConfirmationDialog(
                                          message: "Place order?",
                                          confirmButtonText: "Confirm",
                                          denyButtonText: "Cancel",
                                        );
                                      },
                                    ).then(
                                      (confirmed) {
                                        if (confirmed) {
                                          BlocProvider.of<CartBloc>(context)
                                              .add(
                                            CartOrderPlaced(),
                                          );
                                          BlocProvider.of<GlobalBloc>(context)
                                              .add(
                                            GlobalRequestGoToProfilePage(),
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const ConfirmationDialog(
                                          message: "Log in to place your order",
                                          confirmButtonText: "Log in",
                                          denyButtonText: "Cancel",
                                        );
                                      },
                                    ).then(
                                      (confirmed) {
                                        if (confirmed) {
                                          BlocProvider.of<GlobalBloc>(context)
                                              .add(
                                            GlobalRequestGoToProfilePage(),
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                            ),
                            child: const Text("Checkout"),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
