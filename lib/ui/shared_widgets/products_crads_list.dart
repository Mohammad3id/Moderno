import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/product_screen/product_screen.dart';

class ProductsCradsList extends StatelessWidget {
  final List<ProductBrief> productBriefs;
  final String label;
  final double labelSize;
  final double labelListGap;
  final bool showHeartIcon;

  const ProductsCradsList({
    Key? key,
    required this.productBriefs,
    required this.label,
    this.labelSize = 20,
    this.labelListGap = 15,
    this.showHeartIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            label,
            style: TextStyle(fontSize: labelSize),
          ),
        ),
        SizedBox(
          height: labelListGap,
        ),
        SizedBox(
          height: 160,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productBriefs.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                    bottom: 10,
                    left: 20,
                    right: (index == productBriefs.length - 1) ? 20 : 0),
                child: ProductCard(
                  productBrief: productBriefs[index],
                  showHeartIcon: showHeartIcon,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatefulWidget {
  final bool showHeartIcon;
  const ProductCard({
    Key? key,
    required this.productBrief,
    this.showHeartIcon = true,
  }) : super(key: key);

  final ProductBrief productBrief;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _opened = false;
  bool? _isWishlistedInPage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _opened = true;
        });
        Future.delayed(
          Duration.zero,
        ).then((value) async {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(0, 0, 0, 0),
            ),
          );
          final isWishlistedInPage = await Navigator.of(context).push<bool?>(
            MaterialPageRoute(
              builder: (context) => ProductScreen(
                productId: widget.productBrief.id,
                mainImageUrl: widget.productBrief.imageUrl,
                heroTag: widget.productBrief,
              ),
            ),
          );

          if (isWishlistedInPage != null) {
            setState(() {
              _isWishlistedInPage = isWishlistedInPage;
            });
          }
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(128, 0, 0, 0),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 300));
          setState(
            () {
              _opened = false;
            },
          );
        });
      },
      child: Container(
        height: 150,
        width: 120,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(100, 0, 0, 0),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: widget.productBrief,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    widget.productBrief.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: AnimatedOpacity(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 200),
                opacity: _opened ? 0 : 1,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${formatPrice(widget.productBrief.price)} EGP",
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (widget.productBrief.priceBeforDiscount != null)
                              Text(
                                "${formatPrice(widget.productBrief.priceBeforDiscount!)} EGP",
                                style: const TextStyle(
                                  fontSize: 8,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (widget.showHeartIcon &&
                          (_isWishlistedInPage == null &&
                                  widget.productBrief.isWishlisted ||
                              _isWishlistedInPage != null &&
                                  _isWishlistedInPage!))
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
