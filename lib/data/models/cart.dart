import 'package:moderno/data/models/product.dart';

class Cart {
  final List<CartItem> items;

  int get total {
    return items.isEmpty
        ? 0
        : items.map((item) => item.price).reduce((acc, price) => acc + price);
  }

  int? get totalBeforeDiscount {
    if (items.isEmpty) return null;
    var noDiscount = true;
    final result = items.map((item) {
      if (item.priceBeforeDiscount != null) {
        noDiscount = false;
        return item.priceBeforeDiscount!;
      }
      return item.price;
    }).reduce((acc, price) => acc + price);

    if (noDiscount) return null;
    return result;
  }

  Cart(this.items);
}

class CartItem {
  final String id;
  final Product product;
  final Map<String, String> productAttributes;
  int quantity;

  int get price {
    return product.price * quantity;
  }

  int? get priceBeforeDiscount {
    if (product.priceBeforeDiscount != null) {
      return product.priceBeforeDiscount! * quantity;
    }
    return null;
  }

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.productAttributes,
  });
}
