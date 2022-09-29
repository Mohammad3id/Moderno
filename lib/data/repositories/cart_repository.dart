import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/providers/cart_provider.dart';
import 'package:moderno/data/providers/shared/database_exception.dart';
import 'package:moderno/data/repositories/product_repository.dart';
import 'package:moderno/data/repositories/shared/repository_exception.dart';
import 'package:moderno/data/repositories/user_repository.dart';
import 'package:uuid/uuid.dart';

class CartRepository {
  static CartRepository instance = CartRepository();

  Cart _currentCart = Cart([]);
  Cart get currentCart {
    return _currentCart;
  }

  final _cartProvider = CartProvider.instance;
  final _userRepositoy = UserRepository.instance;
  final _productRepository = ProductRepository.instance;

  Future<Cart> loadCart() async {
    if (await _userRepositoy.isUserSignedIn()) {
      _currentCart =
          await _cartProvider.getUserCart(_userRepositoy.currentUser.id);
    }
    return _currentCart;
  }

  Future<Cart> clearCart() async {
    _currentCart = Cart([]);
    return _currentCart;
  }

  Future<Cart> addProductToCart(
    String productId, {
    required int quantity,
    required Map<String, String> productAttributes,
    bool isBundle = false,
  }) async {
    try {
      increaseCartItemQuantitiy(
        _currentCart.items.firstWhere((item) {
          if (item.product.id != productId) {
            return false;
          }

          for (var attributeLabel in productAttributes.keys) {
            if (productAttributes[attributeLabel] !=
                item.productAttributes[attributeLabel]) {
              return false;
            }
          }

          return true;
        }).id,
      );
      return _currentCart;
    } catch (_) {
      if (!await _userRepositoy.isUserSignedIn()) {
        _currentCart.items.add(
          CartItem(
            id: const Uuid().v4(),
            product: isBundle
                ? await _productRepository.getBundleById(productId)
                : await _productRepository.getProductById(productId),
            quantity: quantity,
            productAttributes: productAttributes,
          ),
        );

        return _currentCart;
      }

      try {
        _currentCart = await _cartProvider.addProductToUserCart(
          _userRepositoy.currentUser.id,
          productId: productId,
          quantity: quantity,
          productAttributes: productAttributes,
          isBundle: isBundle,
        );
        return _currentCart;
      } on DatabaseException catch (e) {
        throw CartRepositoryException(e.message);
      }
    }
  }

  Future<Cart> placeOrder() async {
    if (!await _userRepositoy.isUserSignedIn()) {
      throw UserRepositoryException("Can't place an order as a guest");
    }
    try {
      return await _cartProvider
          .placeOrderFromCart(_userRepositoy.currentUser.id);
    } on DatabaseException catch (e) {
      throw CartRepositoryException(e.message);
    }
  }

  Future<Cart> increaseCartItemQuantitiy(String cartItemId) async {
    if (!await _userRepositoy.isUserSignedIn()) {
      try {
        _currentCart.items
            .firstWhere((item) => cartItemId == item.id)
            .quantity += 1;
        return _currentCart;
      } catch (_) {
        throw CartDatabaseException(
            "Cart item with id ($cartItemId) doesn't exist");
      }
    }

    _currentCart = await _cartProvider.increaseUserCartItemQuantitiy(
      _userRepositoy.currentUser.id,
      cartItemId: cartItemId,
    );

    return _currentCart;
  }

  Future<Cart> decreaseCartItemQuantitiy(String cartItemId) async {
    if (!await _userRepositoy.isUserSignedIn()) {
      try {
        final cartItem =
            _currentCart.items.firstWhere((item) => item.id == cartItemId);

        cartItem.quantity -= 1;

        if (cartItem.quantity <= 0) {
          _currentCart.items.removeWhere((item) => item.id == cartItemId);
        }

        return _currentCart;
      } catch (_) {
        throw CartDatabaseException(
            "Cart item with id ($cartItemId) doesn't exist");
      }
    }

    _currentCart = await _cartProvider.decreaseUserCartItemQuantitiy(
      _userRepositoy.currentUser.id,
      cartItemId: cartItemId,
    );

    return _currentCart;
  }
}

class CartRepositoryException extends RepositoryException {
  CartRepositoryException(super.message);
}
