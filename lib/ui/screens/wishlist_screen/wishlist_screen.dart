import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/wishlist_bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/curves_with_delay.dart';
import 'package:moderno/shared_functionality/fade_in_page_route.dart';
import 'package:moderno/shared_functionality/format_enum.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/product_screen/product_screen.dart';
import 'package:moderno/ui/shared_widgets/app_bottom_navigation_bar.dart';
import 'package:moderno/ui/shared_widgets/app_drawer.dart';
import 'package:moderno/ui/shared_widgets/product_info_tile.dart';
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
                              child: ProductInfoTile(
                                product: product,
                                showFavIcon: false,
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
