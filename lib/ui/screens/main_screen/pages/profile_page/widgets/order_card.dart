import 'package:flutter/material.dart';
import 'package:moderno/data/models/order.dart';
import 'package:moderno/shared_functionality/fade_in_page_route.dart';
import 'package:moderno/shared_functionality/format_date.dart';
import 'package:moderno/shared_functionality/format_price.dart';
import 'package:moderno/ui/screens/order_screen/order_screen.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _showImagesOverlay = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(100, 0, 0, 0),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _showImagesOverlay = false;
            });
            Navigator.of(context)
                .push(
              FadeInPageRoute(
                OrderScreen(order: widget.order),
              ),
            )
                .then((_) {
              Future.delayed(const Duration(milliseconds: 500)).then((_) {
                setState(() {
                  _showImagesOverlay = true;
                });
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                OrderCardImagesGrid(
                  order: widget.order,
                  showOverlay: _showImagesOverlay,
                ),
                const SizedBox(width: 10),
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.order.status == OrderStatus.onTheWay
                            ? "On the way!"
                            : widget.order.status == OrderStatus.processing
                                ? "Processing..."
                                : "Deliverd :)",
                        style: const TextStyle(fontSize: 25),
                      ),
                      Text("Ordered: ${formatDate(widget.order.orderDate)}"),
                      if (widget.order.status == OrderStatus.deliverd)
                        Text(
                            "Delivered: ${formatDate(widget.order.deliveryDate)}")
                      else
                        Text(
                            "Expected Delivery: ${formatDate(widget.order.deliveryDate)}"),
                      Text("Cost: ${formatPrice(widget.order.cart.total)} EGP"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderCardImagesGrid extends StatelessWidget {
  const OrderCardImagesGrid({
    Key? key,
    required this.order,
    required this.showOverlay,
  }) : super(key: key);

  final Order order;
  final bool showOverlay;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: order.cart.items.first.id,
                child: Container(
                  height: order.cart.items.length == 1 ? 105 : 50,
                  width: order.cart.items.length == 1 ? 84 : 40,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(100, 0, 0, 0),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                        order.cart.items.length == 1 ? 10 : 5),
                  ),
                  child: Image.asset(
                    order.cart.items.first.product.imagesUrls.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (order.cart.items.length > 1) ...[
                const SizedBox(height: 5),
                Container(
                  height: 50,
                  width: 40,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(100, 0, 0, 0),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: order.cart.items[1].id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              order.cart.items[1].product.imagesUrls.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (order.cart.items.length == 3)
                        Positioned.fill(
                          child: AnimatedOpacity(
                            opacity: showOverlay ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              color: const Color.fromARGB(100, 0, 0, 0),
                              alignment: Alignment.center,
                              child: const Text("+2"),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ]
            ],
          ),
          if (order.cart.items.length > 3) ...[
            const SizedBox(width: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: order.cart.items[2].id,
                  child: Container(
                    height: 50,
                    width: 40,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(100, 0, 0, 0),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      order.cart.items[2].product.imagesUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 50,
                  width: 40,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(100, 0, 0, 0),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: order.cart.items[3].id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              order.cart.items[3].product.imagesUrls.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (order.cart.items.length > 4)
                        Positioned.fill(
                          child: AnimatedOpacity(
                            opacity: showOverlay ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              color: const Color.fromARGB(100, 0, 0, 0),
                              alignment: Alignment.center,
                              child: const Text("+2"),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            )
          ],
        ],
      ),
    );
  }
}
