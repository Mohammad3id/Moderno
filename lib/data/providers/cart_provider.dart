import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/models/order.dart';
import 'package:moderno/data/providers/product_provider.dart';
import 'package:moderno/data/providers/shared/database_exception.dart';
import 'package:moderno/data/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

class CartProvider {
  static CartProvider instance = CartProvider();

  final _userProvider = UserProvider.instance;
  final _productProvider = ProductProvider.instance;

  Future<Cart> getUserCart(String userId) async {
    return (await _userProvider.getUserById(userId)).cart;
  }

  Future<Cart> addProductToUserCart(
    String userId, {
    required String productId,
    required int quantity,
    required Map<String, String> productAttributes,
    bool isBundle = false,
  }) async {
    final databaseUser = await _userProvider.getUserById(userId);
    final product = isBundle
        ? await _productProvider.getBundleById(productId)
        : await _productProvider.getProductById(productId);
    databaseUser.cart.items.add(
      CartItem(
        id: const Uuid().v4(),
        product: product,
        quantity: quantity,
        productAttributes: productAttributes,
      ),
    );

    return databaseUser.cart;
  }

  Future<Cart> increaseUserCartItemQuantitiy(
    String userId, {
    required String cartItemId,
  }) async {
    final databaseUser = await _userProvider.getUserById(userId);

    try {
      databaseUser.cart.items
          .firstWhere((item) => item.id == cartItemId)
          .quantity += 1;
    } catch (_) {
      throw UserDatabaseException("Cart item doesn't exist");
    }

    return databaseUser.cart;
  }

  Future<Cart> decreaseUserCartItemQuantitiy(
    String userId, {
    required String cartItemId,
  }) async {
    DatabaseUser databaseUser;
    databaseUser = await _userProvider.getUserById(userId);

    try {
      final cartItem =
          databaseUser.cart.items.firstWhere((item) => item.id == cartItemId);

      cartItem.quantity -= 1;

      if (cartItem.quantity <= 0) {
        databaseUser.cart.items.removeWhere((item) => item.id == cartItemId);
      }
    } catch (_) {
      throw UserDatabaseException("Cart item doesn't exist");
    }

    return databaseUser.cart;
  }

  Future<Cart> placeOrderFromCart(String userId) async {
    try {
      final databaseUser = await _userProvider.getUserById(userId);

      if (databaseUser.cart.items.isEmpty) {
        throw CartDatabaseException("User cart is empty");
      }

      int minDeliveryDays = 0;
      int maxDeliveryDays = 0;

      for (final deliveryDays in databaseUser.cart.items
          .map((item) => item.product.expectedDeliveryTime)) {
        if (minDeliveryDays < deliveryDays.minDeliveryDays) {
          minDeliveryDays = deliveryDays.minDeliveryDays;
        }
        if (maxDeliveryDays < deliveryDays.maxDeliveryDays) {
          maxDeliveryDays = deliveryDays.maxDeliveryDays;
        }
      }

      databaseUser.orders.insert(
        0,
        Order(
          id: const Uuid().v4(),
          orderDate: DateTime.now(),
          cart: databaseUser.cart,
          status: OrderStatus.processing,
          deliveryDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ).add(
            Duration(
              days: ((maxDeliveryDays + minDeliveryDays) ~/ 2),
            ),
          ),
        ),
      );
      databaseUser.cart = Cart([]);
      return databaseUser.cart;
    } catch (_) {
      throw CartDatabaseException("User doesn't exist");
    }
  }
}

class CartDatabaseException extends DatabaseException {
  CartDatabaseException(super.message);
}
