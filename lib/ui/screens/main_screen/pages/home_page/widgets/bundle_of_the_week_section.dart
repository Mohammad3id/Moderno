import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/product_screen/product_screen.dart';

class BundleOfTheWeekSection extends StatelessWidget {
  final Bundle bundle;
  const BundleOfTheWeekSection(this.bundle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    "Bundle of the Week",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    bundle.description,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${formatPrice(bundle.price)} EGP",
                              style: const TextStyle(fontSize: 20),
                            ),
                            if (bundle.priceBeforeDiscount != null)
                              Text(
                                "${formatPrice(bundle.priceBeforeDiscount!)} EGP",
                                style: const TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough),
                              ),
                          ],
                        ),
                      ),
                      const Text(
                        "Offer available \ntill next Friday",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.normal),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text("Check it out!"),
                      onPressed: () {
                        showDialog<bool>(
                          context: context,
                          builder: (context) =>
                              BundleDetailsDialog(bundle: bundle),
                        ).then((showBundlePage) {
                          if (showBundlePage != null && showBundlePage) {
                            Future.delayed(const Duration(milliseconds: 200))
                                .then((value) {
                              SystemChrome.setSystemUIOverlayStyle(
                                const SystemUiOverlayStyle(
                                  statusBarColor: Color.fromARGB(0, 0, 0, 0),
                                ),
                              );
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                    productId: bundle.id,
                                    mainImageUrl: bundle.imagesUrls.first,
                                    heroTag: bundle,
                                    isBundle: true,
                                  ),
                                ),
                              )
                                  .then((value) {
                                SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                    statusBarColor:
                                        Color.fromARGB(128, 0, 0, 0),
                                  ),
                                );
                              });
                            });
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: Color.fromARGB(0, 0, 0, 0),
                ),
              );
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductScreen(
                    productId: bundle.id,
                    mainImageUrl: bundle.imagesUrls.first,
                    heroTag: bundle,
                    isBundle: true,
                  ),
                ),
              );
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: Color.fromARGB(128, 0, 0, 0),
                ),
              );
            },
            child: Hero(
              tag: bundle,
              child: Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(100, 0, 0, 0),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Image.asset(bundle.imagesUrls.first),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BundleDetailsDialog extends StatelessWidget {
  const BundleDetailsDialog({
    Key? key,
    required this.bundle,
  }) : super(key: key);

  final Bundle bundle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    const Text(
                      "Bundle of the Week",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(100, 0, 0, 0),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                width: 200,
                height: 200,
                child: Image.asset(
                  bundle.imagesUrls.first,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 15,
                  top: 20,
                ),
                child: Text(bundle.description),
              ),
              ...bundle.descriptionParagraphs.map(
                (paragraph) => Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15,
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
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${formatPrice(bundle.price)} EGP",
                          style: const TextStyle(fontSize: 22),
                        ),
                        if (bundle.priceBeforeDiscount != null)
                          Text(
                            "${formatPrice(bundle.priceBeforeDiscount!)} EGP",
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                      ),
                      child: const Text("View Bundle"),
                    ),
                  ],
                ),
              ),
              const Text(
                "Offer available till next Friday",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
