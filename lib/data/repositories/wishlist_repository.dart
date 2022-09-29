import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/providers/shared/database_exception.dart';
import 'package:moderno/data/providers/wishlist_provider.dart';
import 'package:moderno/data/repositories/shared/repository_exception.dart';

import 'product_repository.dart';
import 'user_repository.dart';

class WishlistRepository {
  static WishlistRepository instance = WishlistRepository();

  List<Product> _currentWishlist = [];
  List<Product> get currentWishlist {
    return _currentWishlist;
  }

  final _wishlistProvider = wishlistProviderInstance;
  final _userRepositoy = UserRepository.instance;
  final _productRepository = ProductRepository.instance;

  Future<List<Product>> loadWishlist() async {
    if (await _userRepositoy.isUserSignedIn()) {
      _currentWishlist = await _wishlistProvider
          .getUserWishlist(_userRepositoy.currentUser.id);
    }
    return _currentWishlist;
  }

  Future<List<Product>> clearWishlist() async {
    _currentWishlist = [];
    return _currentWishlist;
  }

  Future<List<Product>> addProductToWishlist({
    required String productId,
    isBundle = false,
  }) async {
    if (!await _userRepositoy.isUserSignedIn()) {
      try {
        final product = isBundle
            ? await _productRepository.getBundleById(productId)
            : await _productRepository.getProductById(productId);
        _currentWishlist.add(product);
        return _currentWishlist;
      } on ProductRepositoryException catch (e) {
        throw WishlistRepositoryException(e.message);
      }
    } else {
      try {
        _currentWishlist = await _wishlistProvider.addProductToWishlist(
          userId: _userRepositoy.currentUser.id,
          productId: productId,
          isBundle: isBundle,
        );
        return _currentWishlist;
      } on DatabaseException catch (e) {
        throw WishlistRepositoryException(e.message);
      }
    }
  }

  Future<List<Product>> removeProductFromWishlist({
    required String productId,
    bool isBundle = false,
  }) async {
    if (!await _userRepositoy.isUserSignedIn()) {
      _currentWishlist.removeWhere((product) => product.id == productId);
      return _currentWishlist;
    } else {
      try {
        _currentWishlist = await _wishlistProvider.removeProductFromWishlist(
          userId: _userRepositoy.currentUser.id,
          productId: productId,
          isBundle: isBundle,
        );
        return _currentWishlist;
      } on DatabaseException catch (e) {
        throw WishlistRepositoryException(e.message);
      }
    }
  }

  Future<bool> isProductWishlisted(
    String productId,
  ) async {
    if (!await _userRepositoy.isUserSignedIn()) {
      return _currentWishlist.any((product) => product.id == productId);
    } else {
      try {
        return await _wishlistProvider.isProductWishlisted(
          userId: _userRepositoy.currentUser.id,
          productId: productId,
        );
      } on DatabaseException catch (e) {
        throw WishlistRepositoryException(e.message);
      }
    }
  }
}

class WishlistRepositoryException extends RepositoryException {
  WishlistRepositoryException(super.message);
}
