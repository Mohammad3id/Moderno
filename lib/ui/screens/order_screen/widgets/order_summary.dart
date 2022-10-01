import 'package:flutter/material.dart';
import 'package:moderno/data/models/order.dart';
import 'package:moderno/shared_functionality/format_date.dart';
import 'package:moderno/shared_functionality/format_price.dart';

class OrderSummary extends StatelessWidget {
  final Order order;
  const OrderSummary({
    super.key,
    required this.order,
    required this.showDivider,
  });

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80.5,
      child: Stack(
        children: [
          AnimatedOpacity(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 200),
            opacity: showDivider ? 1 : 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 0.5,
              decoration: const BoxDecoration(
                color: Colors.black54,
                boxShadow: [
                  BoxShadow(offset: Offset(0, -1), blurRadius: 5),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 0.5,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 30,
              ),
              child: Table(
                columnWidths: const {
                  1: IntrinsicColumnWidth(),
                },
                children: [
                  TableRow(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            "${formatPrice(order.cart.total)} EGP",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          if (order.cart.totalBeforeDiscount != null)
                            Text(
                              "${formatPrice(order.cart.totalBeforeDiscount!)} EGP",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            order.status == OrderStatus.onTheWay
                                ? "On The Way!"
                                : order.status == OrderStatus.deliverd
                                    ? "Delivered :)"
                                    : "Processing...",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const TableRow(children: [
                    SizedBox(height: 10),
                    SizedBox(),
                  ]),
                  TableRow(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Order Date",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            formatDate(order.orderDate),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            order.status == OrderStatus.deliverd
                                ? "Delivery Date"
                                : "Expected Delivery Date",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            formatDate(order.deliveryDate),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
