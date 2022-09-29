import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/product_bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/format_dimension.dart';
import 'package:moderno/shared_functionality/format_enum.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/shared_widgets/products_crads_list.dart';

import 'add_to_cart_dialog.dart';
import 'product_attribute_options_selector.dart';

class ProductDetails extends StatelessWidget {
  final ProductBloc productBloc;
  const ProductDetails(
    this.productBloc, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = productBloc.state as ProductDataLoadSuccess;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formateEnum(state.stockStatus),
                          style: TextStyle(
                            color:
                                state.stockStatus == ProductStockStatus.inStock
                                    ? Colors.green
                                    : state.stockStatus ==
                                            ProductStockStatus.inStockSoon
                                        ? Colors.blue
                                        : Colors.red,
                          ),
                        ),
                        Text(
                          "${formatPrice(state.price)} EGP",
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        if (state.priceBeforeDiscount != null)
                          Text(
                            "${formatPrice(state.priceBeforeDiscount!)} EGP",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddToCartDialog(
                            selectedAttributesOptions:
                                state.selectedAttributesOptions,
                            dialogTitle: state.name,
                            productId: state.productId,
                            productBloc: productBloc,
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (state.isWishlisted) {
                        BlocProvider.of<ProductBloc>(context).add(
                          ProductRemovedFromWishlist(),
                        );
                      } else {
                        BlocProvider.of<ProductBloc>(context).add(
                          ProductAddedToWishlist(),
                        );
                      }
                    },
                    icon: Icon(
                      state.isWishlisted
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            ...state.attributesOptions.keys.map(
              (attributeLabel) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProductAttributeOptionsSelector(
                  attributeLabel: attributeLabel,
                  attributeOptions: state.attributesOptions[attributeLabel]!,
                  selectedAttributesOption:
                      state.selectedAttributesOptions[attributeLabel]!,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                  top: 35,
                  bottom: 30,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Text(state.description),
                    if (state is ProductBundleDataLoadSuccess)
                      ...state.descriptionParagraphs.map(
                        (paragraph) => Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Flex(
                            direction: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("•  "),
                              Flexible(
                                flex: 1,
                                child: Text(paragraph),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                )),
            if (state is ProductBundleDataLoadSuccess)
              ProductsCradsList(
                productBriefs: state.bundleProducts,
                label: "Bundle Products",
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dimensions",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Length\n${formatDimension(state.dimensions.length)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, right: 10),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Width\n${formatDimension(state.dimensions.width)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, right: 10),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Height\n${formatDimension(state.dimensions.height)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
