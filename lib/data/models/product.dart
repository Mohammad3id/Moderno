class Product {
  final String id;
  final String name;
  final ProductCategory category;
  final Map<String, List<String>> attributesOptions;
  final Map<String, String> defaultAttributesOptions;
  final String description;
  final ProductDimensions dimensions;
  final int price;
  final int? priceBeforeDiscount;
  final ProductDeliveryTime expectedDeliveryTime;
  final List<String> imagesUrls;
  final ProductStockStatus stockStatus;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.attributesOptions,
    required this.defaultAttributesOptions,
    required this.description,
    required this.dimensions,
    required this.price,
    this.priceBeforeDiscount,
    required this.expectedDeliveryTime,
    required this.imagesUrls,
    required this.stockStatus,
  });
}

class ProductBrief {
  final String id;
  final String imageUrl;
  final bool isWishlisted;
  final int price;
  final int? priceBeforDiscount;

  ProductBrief({
    required this.id,
    required this.imageUrl,
    required this.isWishlisted,
    required this.price,
    this.priceBeforDiscount,
  });
}

class ProductInfo {
  final String id;
  final String name;
  final ProductStockStatus stockStatus;
  final String imageUrl;
  final bool isWishlisted;
  final bool isBundle;
  final int price;
  final int? priceBeforeDiscount;

  ProductInfo({
    required this.id,
    required this.name,
    required this.stockStatus,
    required this.imageUrl,
    required this.isWishlisted,
    required this.price,
    required this.isBundle,
    this.priceBeforeDiscount,
  });
}

class Bundle extends Product {
  final List<String> descriptionParagraphs;
  final List<Product> bundleProducts;

  Bundle({
    required super.id,
    required super.name,
    required super.attributesOptions,
    required super.defaultAttributesOptions,
    required super.description,
    required this.descriptionParagraphs,
    required super.price,
    required super.priceBeforeDiscount,
    required super.expectedDeliveryTime,
    required super.imagesUrls,
    required super.stockStatus,
    required this.bundleProducts,
  }) : super(
          category: ProductCategory.bundle,
          dimensions: ProductDimensions(
            height: 0,
            length: 0,
            width: 0,
          ),
        );
}

class ProductDeliveryTime {
  final int minDeliveryDays;
  final int maxDeliveryDays;

  ProductDeliveryTime({
    required this.minDeliveryDays,
    required this.maxDeliveryDays,
  });
}

class ProductDimensions {
  final int length;
  final int width;
  final int height;

  ProductDimensions({
    required this.length,
    required this.width,
    required this.height,
  });
}

enum ProductStockStatus {
  inStock,
  outOfStock,
  inStockSoon,
  onlyFewUnitsLeft,
}

enum ProductCategory {
  chairs,
  tables,
  couches,
  beds,
  lamps,
  closets,
  mirrors,
  drawer,
  bundle,
}

enum ProductSort {
  byNameAscending,
  byNameDescending,
  byPriceAscending,
  byPriceDescending,
}
