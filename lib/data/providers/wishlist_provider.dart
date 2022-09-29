import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/providers/shared/database_exception.dart';

import 'product_provider.dart';
import 'user_provider.dart';

final wishlistProviderInstance = WishlistProvider();

class WishlistProvider {
  static WishlistProvider instance = WishlistProvider();

  final _userProvider = UserProvider.instance;
  final _productProvider = ProductProvider.instance;

  Future<List<Product>> getUserWishlist(String userId) async {
    return (await _userProvider.getUserById(userId)).wishlist;
  }

  Future<List<Product>> addProductToWishlist({
    required String userId,
    required String productId,
    bool isBundle = false,
  }) async {
    try {
      final databaseUser = await _userProvider.getUserById(userId);
      final product = isBundle
          ? await _productProvider.getBundleById(productId)
          : await _productProvider.getProductById(productId);
      databaseUser.wishlist.add(product);
      return databaseUser.wishlist;
    } on DatabaseException catch (e) {
      throw WishlistDatabaseException(e.message);
    }
  }

  Future<List<Product>> removeProductFromWishlist({
    required String userId,
    required String productId,
    bool isBundle = false,
  }) async {
    try {
      final databaseUser = await _userProvider.getUserById(userId);
      databaseUser.wishlist.removeWhere((product) => product.id == productId);
      return databaseUser.wishlist;
    } on DatabaseException catch (e) {
      throw WishlistDatabaseException(e.message);
    }
  }

  Future<bool> isProductWishlisted({
    required String userId,
    required String productId,
  }) async {
    try {
      final databaseUser = await _userProvider.getUserById(userId);
      return databaseUser.wishlist.any((product) => product.id == productId);
    } on DatabaseException catch (e) {
      throw WishlistDatabaseException(e.message);
    }
  }
}

class WishlistDatabaseException extends DatabaseException {
  WishlistDatabaseException(super.message);
}
