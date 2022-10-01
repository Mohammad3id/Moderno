import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/product_bloc.dart';
import 'package:moderno/ui/screens/product_screen/widgets/product_images_swiper_dialog.dart';

import 'widgets/product_details.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  final String mainImageUrl;
  final Object heroTag;
  final bool isBundle;
  final Map<String, String>? startingAttributes;
  const ProductScreen({
    required this.productId,
    required this.mainImageUrl,
    required this.heroTag,
    this.isBundle = false,
    this.startingAttributes,
    super.key,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _screenOpened = false;
  bool _showBackButton = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100)).then(
      (_) => setState(
        () {
          _screenOpened = true;
        },
      ),
    );
    Future.delayed(const Duration(milliseconds: 300)).then(
      (_) => setState(
        () {
          _showBackButton = true;
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(widget.productId,
          isBundle: widget.isBundle,
          startingAttributes: widget.startingAttributes),
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state is ProductInteractionSuccess) {
            if (state.interactionType == ProductInteractionTypes.addToCart) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product added to cart"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.interactionType ==
                ProductInteractionTypes.addToWishlist) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product added to wishlist"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.interactionType ==
                ProductInteractionTypes.removeFromWishlist) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Product removed from wishlist"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } else if (state is ProductInteractionFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("An error occured: ${state.errorMessage}"),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is ProductBundleInteractionSuccess) {
            if (state.interactionType == ProductInteractionTypes.addToCart) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bundle added to cart"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.interactionType ==
                ProductInteractionTypes.addToWishlist) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bundle added to wishlist"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state.interactionType ==
                ProductInteractionTypes.removeFromWishlist) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bundle removed from wishlist"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } else if (state is ProductBundleInteractionFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("An error occured: ${state.errorMessage}"),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is ProductDataLoadSuccess) {
                Navigator.of(context).pop(state.isWishlisted);
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (state is ProductDataLoadSuccess) {
                          showDialog(
                            context: context,
                            builder: (context) => ProductImagesSwiperDialog(
                              imagesUrls: state.imagesUrls,
                            ),
                          );
                        }
                      },
                      child: Hero(
                        tag: widget.heroTag,
                        child: SizedBox(
                          height: 250,
                          child: Image.asset(
                            widget.mainImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: AnimatedOpacity(
                      opacity: _showBackButton ? 1 : 0,
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        padding: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                  state is ProductDataLoadSuccess
                                      ? state.isWishlisted
                                      : null,
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            if (state is ProductDataLoadSuccess)
                              Text(
                                state.name,
                                style: const TextStyle(color: Colors.white),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 300),
                    top: _screenOpened
                        ? 200
                        : MediaQuery.of(context).size.height,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height - 200,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Builder(
                        builder: (context) {
                          if (state is ProductDataLoadFail) {
                            return Center(
                              child: Text(
                                "Product data load faild: ${state.errorMessage}",
                              ),
                            );
                          } else if (state is ProductDataLoadSuccess) {
                            return ProductDetails(
                                BlocProvider.of<ProductBloc>(context));
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
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
          );
        },
      ),
    );
  }
}
