import 'package:flutter/material.dart';
import 'package:moderno/data/models/order.dart';
import 'package:moderno/shared_functionality/format_date.dart';
import 'package:moderno/shared_functionality/format_price.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(10),
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
      child: Row(
        children: [
          OrderCardImagesGrid(order: order),
          const SizedBox(width: 10),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  order.status == OrderStatus.onTheWay
                      ? "On the way!"
                      : order.status == OrderStatus.processing
                          ? "Processing..."
                          : "Deliverd :)",
                  style: const TextStyle(fontSize: 25),
                ),
                Text("Ordered: ${formatDate(order.orderDate)}"),
                if (order.status == OrderStatus.deliverd)
                  Text("Delivered: ${formatDate(order.deliveryDate)}")
                else
                  Text("Expected Delivery: ${formatDate(order.deliveryDate)}"),
                Text("Cost: ${formatPrice(order.cart.total)} EGP"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderCardImagesGrid extends StatelessWidget {
  const OrderCardImagesGrid({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
                      child: Image.asset(
                        order.cart.items[1].product.imagesUrls.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (order.cart.items.length == 3)
                      Positioned.fill(
                        child: Container(
                          color: const Color.fromARGB(100, 0, 0, 0),
                          alignment: Alignment.center,
                          child: const Text("+2"),
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
                child: Image.asset(
                  order.cart.items[2].product.imagesUrls.first,
                  fit: BoxFit.cover,
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
                        child: Image.asset(
                          order.cart.items[3].product.imagesUrls.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (order.cart.items.length > 4)
                        Positioned.fill(
                          child: Container(
                            color: const Color.fromARGB(100, 0, 0, 0),
                            alignment: Alignment.center,
                            child: const Text("+2"),
                          ),
                        )
                    ],
                  ),
                ),
              ]
            ],
          )
        ],
      ],
    );
  }
}
