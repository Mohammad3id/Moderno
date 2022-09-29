import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/providers/product_provider.dart';
import 'package:moderno/data/repositories/shared/repository_exception.dart';

class ProductRepository {
  static ProductRepository instance = ProductRepository();

  final _productProvider = ProductProvider.instance;

  Future<Product> getProductById(String id) async {
    try {
      return await _productProvider.getProductById(id);
    } on ProductDatabaseException catch (e) {
      throw ProductRepositoryException(e.message);
    }
  }

  Future<List<Product>> getDeals() async {
    return await _productProvider.getProductsRandomly(
      count: 7,
      condition: (product) => product.priceBeforeDiscount != null,
    );
  }

  Future<Map<ProductCategory, List<Product>>> getFeaturedProducts() async {
    Map<ProductCategory, List<Product>> featuredProducts = {};
    final categories = ProductCategory.values.toList();
    categories.shuffle();
    for (final category in categories) {
      final products = await _productProvider.getProductsRandomly(
        count: 7,
        condition: (product) => product.category == category,
      );

      if (products.isEmpty) continue;

      featuredProducts[category] = products;

      if (featuredProducts.length >= 4) break;
    }
    return featuredProducts;
  }

  Future<List<Product>> searchProducts(
    String search, {
    int pageSize = 10,
    String? startSearchingFromProductId,
    bool Function(Product)? condition,
    ProductSort? sort,
  }) async {
    condition ??= (p) => true;
    return await _productProvider.paginateProducts(
      pageSize: pageSize,
      startAfterProductId: startSearchingFromProductId,
      sort: sort,
      condition: (product) {
        for (final word in search.split(" ")) {
          if (condition!(product) &&
                  product.description.contains(
                    RegExp(word),
                  ) ||
              product.name.contains(
                RegExp(word),
              ) ||
              product.attributesOptions.keys.any(
                (key) => key.contains(
                  RegExp(word),
                ),
              ) ||
              product.attributesOptions.values.any(
                (values) => values.any(
                  (value) => value.contains(
                    RegExp(word),
                  ),
                ),
              ) ||
              product.category.name.contains(
                RegExp(word),
              )) {
            return true;
          }
        }
        return false;
      },
    );
  }

  Future<Bundle?> getBundleOfTheWeek() async {
    return await _productProvider.getBundleOfTheWeek();
  }

  Future<Bundle> getBundleById(String id) async {
    try {
      return await _productProvider.getBundleById(id);
    } on ProductDatabaseException catch (e) {
      throw ProductRepositoryException(e.message);
    }
  }
}

class ProductRepositoryException extends RepositoryException {
  ProductRepositoryException(super.message);
}
