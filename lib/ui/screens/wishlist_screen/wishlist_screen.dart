import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/wishlist_bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/curves_with_delay.dart';
import 'package:moderno/shared_functionality/format_enum.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/product_screen/product_screen.dart';
import 'package:moderno/ui/shared_widgets/app_bottom_navigation_bar.dart';
import 'package:moderno/ui/shared_widgets/app_drawer.dart';
import 'package:moderno/ui/shared_widgets/top_bar.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: AppBottomNavigationBar.outsideMainScreen(),
        drawer: const AppDrawer(currentScreen: "Wishlist"),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const TopBar(),
              Expanded(
                child: BlocProvider(
                  create: (context) => WishlistBloc(),
                  child: BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, state) {
                      if (state is WishlistLoadFailed) {
                        return Center(
                          child: Text(
                            "Error occured when loading wishlist: ${state.errorMessage}",
                          ),
                        );
                      } else if (state is WishlistLoadSucess) {
                        if (state.wishlist.isEmpty) {
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
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 80),
                                child: Center(
                                  child: Text(
                                    "Wishlist is Empty",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Color.fromARGB(100, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 5,
                            bottom: 60,
                          ),
                          itemCount: state.wishlist.length,
                          itemBuilder: (context, index) {
                            final product = state.wishlist[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  // Image
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                            productId: product.id,
                                            mainImageUrl: product.imageUrl,
                                            heroTag: product,
                                            isBundle: product.isBundle,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: product,
                                      child: Container(
                                        width: 100,
                                        height: 125,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(100, 0, 0, 0),
                                              offset: Offset(0, 4),
                                              blurRadius: 4,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Image.asset(
                                          product.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Nmae and Stock Status
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formateEnum(product.stockStatus),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: product.stockStatus ==
                                                        ProductStockStatus
                                                            .inStock
                                                    ? Colors.green
                                                    : product.stockStatus ==
                                                            ProductStockStatus
                                                                .inStockSoon
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
                                                    product.name,
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (product.isBundle)
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 3,
                                                      horizontal: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: const Text(
                                                      "Bundle",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            // price
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Price",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 10),
                                                ),
                                                const SizedBox(height: 1),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${formatPrice(product.price)} EGP",
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          height: 0.95),
                                                    ),
                                                    if (product
                                                            .priceBeforeDiscount !=
                                                        null)
                                                      Text(
                                                        "${formatPrice(product.priceBeforeDiscount!)} EGP",
                                                        style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                  ],
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
                          },
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
