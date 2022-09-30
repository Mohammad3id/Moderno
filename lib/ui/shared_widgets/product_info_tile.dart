import 'package:flutter/material.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/fade_in_page_route.dart';
import 'package:moderno/shared_functionality/format_enum.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/product_screen/product_screen.dart';

class ProductInfoTile extends StatefulWidget {
  final showFavIcon;
  final void Function(bool isWishlisted)? onFavIconPressed;
  const ProductInfoTile({
    Key? key,
    required this.product,
    this.showFavIcon = true,
    this.onFavIconPressed,
  }) : super(key: key);

  final ProductInfo product;

  @override
  State<ProductInfoTile> createState() => _ProductInfoTileState();
}

class _ProductInfoTileState extends State<ProductInfoTile> {
  bool? _isWishlisted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        GestureDetector(
          onTap: () async {
            final isWishlistedInProductScreen =
                await Navigator.of(context).push(
              FadeInPageRoute(
                ProductScreen(
                  productId: widget.product.id,
                  mainImageUrl: widget.product.imageUrl,
                  heroTag: widget.product,
                  isBundle: widget.product.isBundle,
                ),
              ),
            );

            setState(() {
              _isWishlisted = isWishlistedInProductScreen;
            });
          },
          child: Hero(
            tag: widget.product,
            child: Container(
              width: 100,
              height: 125,
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
                widget.product.imageUrl,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formateEnum(widget.product.stockStatus),
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.product.stockStatus ==
                              ProductStockStatus.inStock
                          ? Colors.green
                          : widget.product.stockStatus ==
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
                          widget.product.name,
                          style: const TextStyle(fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.product.isBundle)
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
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        "${formatPrice(widget.product.price)} EGP",
                        style: const TextStyle(fontSize: 20, height: 0.95),
                      ),
                      if (widget.product.priceBeforeDiscount != null)
                        Text(
                          "${formatPrice(widget.product.priceBeforeDiscount!)} EGP",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isWishlisted =
                            !(_isWishlisted ?? widget.product.isWishlisted);
                        widget.onFavIconPressed!(_isWishlisted!);
                      });
                    },
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                      (_isWishlisted ?? widget.product.isWishlisted)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
