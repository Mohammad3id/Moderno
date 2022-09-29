import 'package:moderno/data/models/cart.dart';

class Order {
  final String id;
  final Cart cart;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime deliveryDate;

  Order({
    required this.id,
    required this.cart,
    required this.status,
    required this.orderDate,
    required this.deliveryDate,
  });
}

enum OrderStatus {
  processing,
  onTheWay,
  deliverd,
}
