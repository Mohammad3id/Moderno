import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import "package:collection/collection.dart";

class ProductImagesSwiperDialog extends StatefulWidget {
  final List<String> imagesUrls;
  const ProductImagesSwiperDialog({super.key, required this.imagesUrls});

  @override
  State<ProductImagesSwiperDialog> createState() =>
      _ProductImagesSwiperDialogState();
}

class _ProductImagesSwiperDialogState extends State<ProductImagesSwiperDialog> {
  var _currentNewsIndex = 0;
  final PageController _newsController = PageController(viewportFraction: 0.7);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 2),
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: _newsController,
              onPageChanged: (index) => setState(
                () {
                  _currentNewsIndex = index;
                },
              ),
              children: widget.imagesUrls
                  .mapIndexed(
                    (index, imageUrl) => Center(
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        scale: _currentNewsIndex == index ? 1 : 0.8,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(100, 0, 0, 0),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: widget.imagesUrls
                  .mapIndexed(
                    (index, _) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: index == _currentNewsIndex ? 15 : 10,
                      height: index == _currentNewsIndex ? 15 : 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: index == _currentNewsIndex
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
