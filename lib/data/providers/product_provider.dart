import 'package:moderno/data/models/product.dart';
import 'package:uuid/uuid.dart';

import 'shared/database_exception.dart';

class ProductProvider {
  static ProductProvider instance = ProductProvider();

  final _productsDB = productsDatabase;
  final _bundlesDB = bundlesDatabase;
  final Map<ProductSort, List<Product>> _sortedProductsDB = {};

  ProductProvider() {
    var sortedProductsDB = [..._productsDB];
    sortedProductsDB
        .sort((product1, product2) => product1.name.compareTo(product2.name));
    _sortedProductsDB[ProductSort.byNameAscending] = sortedProductsDB;
    _sortedProductsDB[ProductSort.byNameDescending] =
        sortedProductsDB.reversed.toList();

    sortedProductsDB = [..._productsDB];
    sortedProductsDB
        .sort((product1, product2) => product1.price.compareTo(product2.price));
    _sortedProductsDB[ProductSort.byPriceAscending] = sortedProductsDB;
    _sortedProductsDB[ProductSort.byPriceDescending] =
        sortedProductsDB.reversed.toList();
  }

  Future<List<Product>> paginateProducts({
    int pageSize = 5,
    String? startAfterProductId,
    bool Function(Product)? condition,
    ProductSort? sort,
  }) async {
    condition ??= (p) => true;
    final productsDB = sort == null ? _productsDB : _sortedProductsDB[sort]!;
    final startIndex = startAfterProductId == null
        ? 0
        : productsDB.indexWhere(
              (product) => product.id == startAfterProductId,
            ) +
            1;

    if (startIndex == 0 && startAfterProductId != null) {
      throw ProductDatabaseException(
        "product with id ($startAfterProductId) doesn't exist in database",
      );
    }

    return productsDB.skip(startIndex).where(condition).take(pageSize).toList();
  }

  Future<List<Product>> getProductsRandomly({
    int count = 5,
    bool Function(Product)? condition,
    ProductSort? sort,
  }) async {
    condition ??= (p) => true;
    final productsPool = _productsDB.where(condition);
    final productsIndecies =
        List.generate(productsPool.length, (index) => index);
    productsIndecies.shuffle();

    return productsIndecies
        .map((i) => productsPool.elementAt(i))
        .take(count)
        .toList();
  }

  Future<Product> getProductById(String id) async {
    try {
      return _productsDB.firstWhere((product) => product.id == id);
    } catch (_) {
      throw ProductDatabaseException("Product with id ($id) doesn't exist");
    }
  }

  Future<List<Product>> getProductsByIds(List<String> ids) async {
    return _productsDB.where((product) => ids.contains(product.id)).toList();
  }

  Future<Bundle?> getBundleOfTheWeek() async {
    if (_bundlesDB.isNotEmpty) {
      return _bundlesDB.last;
    }
    return null;
  }

  Future<Bundle> getBundleById(String id) async {
    try {
      return _bundlesDB.firstWhere((bundle) => bundle.id == id);
    } catch (_) {
      throw ProductDatabaseException("Bundle with id ($id) doesn't exist");
    }
  }
}

class ProductDatabaseException extends DatabaseException {
  ProductDatabaseException(super.message);
}

List<Product> productsDatabase = [
  Product(
    id: const Uuid().v4(),
    name: "Simple Chair with Wooden Legs",
    category: ProductCategory.chairs,
    attributesOptions: {
      "Color": [
        "#000000",
        "#79A788",
        "#4CADD7",
        "#FFFFFF",
      ]
    },
    defaultAttributesOptions: {
      "Color": "#000000",
    },
    description: "Simple plastic chair. Perfect for classrooms.",
    dimensions: ProductDimensions(
      height: 100,
      width: 50,
      length: 50,
    ),
    price: 499,
    priceBeforeDiscount: 749,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 1, maxDeliveryDays: 3),
    imagesUrls: [
      "images/products/product0_0.jpg",
      "images/products/product0_1.jpg",
      "images/products/product0_2.jpg",
    ],
    stockStatus: ProductStockStatus.inStock,
  ),
  Product(
    id: const Uuid().v4(),
    name: "Modern Hanging Lighting",
    category: ProductCategory.lamps,
    attributesOptions: {
      "Color": [
        "#B77740",
        "#2B94F5",
        "#FFFFFF",
      ]
    },
    defaultAttributesOptions: {
      "Color": "#B77740",
    },
    description: "Hanging lighting with stylish and modern look.",
    dimensions: ProductDimensions(
      height: 25,
      width: 20,
      length: 20,
    ),
    price: 349,
    priceBeforeDiscount: 459,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 1, maxDeliveryDays: 3),
    imagesUrls: [
      "images/products/product1_0.jpg",
    ],
    stockStatus: ProductStockStatus.inStock,
  ),
  Product(
    id: const Uuid().v4(),
    name: "Long Fabric Couch",
    category: ProductCategory.couches,
    attributesOptions: {
      "Color": [
        "#253A39",
        "#000000",
      ]
    },
    defaultAttributesOptions: {
      "Color": "#253A39",
    },
    description: "Large comfortable fabric couch.",
    dimensions: ProductDimensions(
      height: 100,
      width: 100,
      length: 290,
    ),
    price: 3299,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 1, maxDeliveryDays: 3),
    imagesUrls: [
      "images/products/product2_0.jpg",
      "images/products/product2_1.jpg",
    ],
    stockStatus: ProductStockStatus.inStock,
  ),
  Product(
    id: const Uuid().v4(),
    name: "Long Leather Couch",
    category: ProductCategory.couches,
    attributesOptions: {
      "Color": [
        "#AD7F51",
        "#000000",
      ],
      "Pillows": [
        "6 Small Pillows",
        "4 Large Pillows",
      ]
    },
    defaultAttributesOptions: {
      "Color": "#AD7F51",
      "Pillows": "6 Small Pillows",
    },
    description: "Large comfortable couch made of fine natural leather.",
    dimensions: ProductDimensions(
      height: 100,
      width: 100,
      length: 300,
    ),
    price: 3499,
    priceBeforeDiscount: 3999,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 1, maxDeliveryDays: 3),
    imagesUrls: [
      "images/products/product3_0.jpg",
      "images/products/product3_1.jpg",
    ],
    stockStatus: ProductStockStatus.inStock,
  ),
  Product(
    id: const Uuid().v4(),
    name: "Bathroom Drawer with Sink",
    category: ProductCategory.drawer,
    attributesOptions: {
      "Color": [
        "#483831",
        "#C2B4A9",
      ],
      "Model": [
        "2 Drawers",
        "1 Drawer and a Shelf",
      ]
    },
    defaultAttributesOptions: {
      "Color": "#483831",
      "Model": "2 Drawers",
    },
    description:
        "Modern bathroom drawer with embedded sink and wooden textures.",
    dimensions: ProductDimensions(
      height: 100,
      width: 100,
      length: 75,
    ),
    price: 1999,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 1, maxDeliveryDays: 3),
    imagesUrls: [
      "images/products/product4_0.jpg",
      "images/products/product4_1.jpg",
      "images/products/product4_2.jpg",
    ],
    stockStatus: ProductStockStatus.onlyFewUnitsLeft,
  ),
  Product(
    id: const Uuid().v4(),
    name: "Modern Bathroom Cabinet",
    category: ProductCategory.closets,
    attributesOptions: {
      "Color": [
        "#483831",
        "#C2B4A9",
      ],
    },
    defaultAttributesOptions: {
      "Color": "#483831",
    },
    description: "Large and modern bathroom cabinet with wooden texture.",
    dimensions: ProductDimensions(
      height: 225,
      width: 75,
      length: 75,
    ),
    price: 3499,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 1, maxDeliveryDays: 3),
    imagesUrls: [
      "images/products/product5_0.jpg",
      "images/products/product5_1.jpg",
      "images/products/product5_2.jpg",
      "images/products/product5_3.jpg",
    ],
    stockStatus: ProductStockStatus.onlyFewUnitsLeft,
  ),
  Product(
    id: const Uuid().v4(),
    name: "Modern Bathroom Mirror",
    category: ProductCategory.mirrors,
    attributesOptions: {
      "Model": [
        "Embedded Light",
        "Mounted Light",
      ],
    },
    defaultAttributesOptions: {
      "Model": "Embedded Light",
    },
    description: "Bathroom mirror with modern looking lights.",
    dimensions: ProductDimensions(
      height: 50,
      width: 75,
      length: 25,
    ),
    price: 999,
    priceBeforeDiscount: 1499,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 1, maxDeliveryDays: 3),
    imagesUrls: [
      "images/products/product6_0.jpg",
      "images/products/product6_1.jpg",
      "images/products/product6_2.jpg",
    ],
    stockStatus: ProductStockStatus.onlyFewUnitsLeft,
  ),
];

List<Bundle> bundlesDatabase = [
  Bundle(
    id: const Uuid().v4(),
    name: "Modern Bathroom Furniture",
    attributesOptions: {
      "Color": [
        "#483831",
        "#C2B4A9",
      ],
      "Drawer Model": [
        "2 Drawers",
        "1 Drawer and a Shelf",
      ],
      "Mirror Model": [
        "Embedded Light",
        "Mounted Light",
      ],
    },
    defaultAttributesOptions: {
      "Color": "#483831",
      "Drawer Model": "2 Drawers",
      "Mirror Model": "Embedded Light",
    },
    description:
        "This bundle will make your bathroom exceptioanlly satisfying.",
    descriptionParagraphs: [
      "Wooden cabinet to store all bathroom-related goodies in.",
      "Simple but stylish sink that matches the cabinet's wooden look and feel.",
      "Beautifully designed mirror with embedded lights to brighten your day."
    ],
    price: 5999,
    priceBeforeDiscount: 6999,
    expectedDeliveryTime:
        ProductDeliveryTime(minDeliveryDays: 3, maxDeliveryDays: 7),
    imagesUrls: [
      "images/bundles/bundle0_0.jpg",
      "images/bundles/bundle0_1.jpg",
      "images/bundles/bundle0_2.jpg",
    ],
    stockStatus: ProductStockStatus.onlyFewUnitsLeft,
    bundleProducts: [
      productsDatabase[4],
      productsDatabase[5],
      productsDatabase[6]
    ],
  )
];
