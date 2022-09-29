import 'package:flutter/material.dart';
import 'package:moderno/data/models/order.dart';

import 'order_card.dart';

class OrdersCradsList extends StatelessWidget {
  final List<Order> orders;
  final String label;
  final double labelSize;
  final double labelListGap;

  const OrdersCradsList({
    Key? key,
    required this.orders,
    required this.label,
    this.labelSize = 20,
    this.labelListGap = 15,
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
          height: 135,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: orders.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                    bottom: 10,
                    left: 20,
                    right: (index == orders.length - 1) ? 20 : 0),
                child: OrderCard(order: orders[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
