import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/repositories/cart_repository.dart';
import 'package:moderno/data/repositories/product_repository.dart';
import 'package:moderno/data/repositories/wishlist_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final _productRepository = ProductRepository.instance;
  final _wishlistRepository = WishlistRepository.instance;
  final _cartRepository = CartRepository.instance;

  final String _productId;
  final bool isBundle;
  ProductBloc(this._productId, {this.isBundle = false})
      : super(ProductInitial()) {
    on<ProductInitialized>(_onProductInitialized);
    on<ProductAttributeOptionSelected>(_onProductAttributeOptionSelected);
    on<ProductAddedToWishlist>(_onProductAddedToWishlist);
    on<ProductRemovedFromWishlist>(_onProductRemovedFromWishlist);
    on<ProductAddedToCart>(_onProductAddedToCart);
    add(ProductInitialized());
  }

  FutureOr<void> _onProductInitialized(
    ProductInitialized event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductDataLoadInProgress());
    try {
      if (isBundle) {
        final bundle = await _productRepository.getBundleById(_productId);
        emit(
          ProductBundleDataLoadSuccess(
            productId: _productId,
            imagesUrls: bundle.imagesUrls,
            stockStatus: bundle.stockStatus,
            price: bundle.price,
            priceBeforeDiscount: bundle.priceBeforeDiscount,
            isWishlisted:
                await _wishlistRepository.isProductWishlisted(_productId),
            expectedDeliveryTime: bundle.expectedDeliveryTime,
            attributesOptions: bundle.attributesOptions,
            selectedAttributesOptions: bundle.defaultAttributesOptions,
            description: bundle.description,
            name: bundle.name,
            descriptionParagraphs: bundle.descriptionParagraphs,
            bundleProducts: await Future.wait(
              bundle.bundleProducts
                  .map(
                    (product) async => ProductBrief(
                      id: product.id,
                      imageUrl: product.imagesUrls.first,
                      isWishlisted: await _wishlistRepository
                          .isProductWishlisted(_productId),
                      price: product.price,
                      priceBeforDiscount: product.priceBeforeDiscount,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      } else {
        final product = await _productRepository.getProductById(_productId);
        emit(
          ProductDataLoadSuccess(
            productId: _productId,
            imagesUrls: product.imagesUrls,
            stockStatus: product.stockStatus,
            price: product.price,
            priceBeforeDiscount: product.priceBeforeDiscount,
            isWishlisted:
                await _wishlistRepository.isProductWishlisted(_productId),
            expectedDeliveryTime: product.expectedDeliveryTime,
            attributesOptions: product.attributesOptions,
            selectedAttributesOptions: product.defaultAttributesOptions,
            description: product.description,
            dimensions: product.dimensions,
            name: product.name,
          ),
        );
      }
    } on ProductRepositoryException catch (e) {
      emit(ProductDataLoadFail(e.message));
    } catch (e) {
      emit(ProductDataLoadFail("Unknown error: $e"));
    }
  }

  FutureOr<void> _onProductAttributeOptionSelected(
      ProductAttributeOptionSelected event, Emitter<ProductState> emit) {
    if (state is! ProductDataLoadSuccess) {
      return null;
    }
    if (isBundle) {
      final castedState = state as ProductBundleDataLoadSuccess;
      final newSelectedAttributeOptions = {
        ...castedState.selectedAttributesOptions
      };
      newSelectedAttributeOptions[event.attributeLabel] = event.attributeValue;
      emit(
        ProductBundleDataLoadSuccess(
          productId: castedState.productId,
          imagesUrls: castedState.imagesUrls,
          stockStatus: castedState.stockStatus,
          price: castedState.price,
          priceBeforeDiscount: castedState.priceBeforeDiscount,
          isWishlisted: castedState.isWishlisted,
          expectedDeliveryTime: castedState.expectedDeliveryTime,
          attributesOptions: castedState.attributesOptions,
          selectedAttributesOptions: newSelectedAttributeOptions,
          description: castedState.description,
          descriptionParagraphs: castedState.descriptionParagraphs,
          bundleProducts: castedState.bundleProducts,
          name: castedState.name,
        ),
      );
    } else {
      final castedState = state as ProductDataLoadSuccess;
      final newSelectedAttributeOptions = {
        ...castedState.selectedAttributesOptions
      };
      newSelectedAttributeOptions[event.attributeLabel] = event.attributeValue;
      emit(
        ProductDataLoadSuccess(
          productId: castedState.productId,
          imagesUrls: castedState.imagesUrls,
          stockStatus: castedState.stockStatus,
          price: castedState.price,
          priceBeforeDiscount: castedState.priceBeforeDiscount,
          isWishlisted: castedState.isWishlisted,
          expectedDeliveryTime: castedState.expectedDeliveryTime,
          attributesOptions: castedState.attributesOptions,
          selectedAttributesOptions: newSelectedAttributeOptions,
          description: castedState.description,
          dimensions: castedState.dimensions,
          name: castedState.name,
        ),
      );
    }
  }

  FutureOr<void> _onProductAddedToWishlist(
    ProductAddedToWishlist event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (isBundle) {
        final castedState = state as ProductBundleDataLoadSuccess;
        emit(
          ProductBundleInteractionSuccess(
            interactionType: ProductInteractionTypes.addToWishlist,
            descriptionParagraphs: castedState.descriptionParagraphs,
            bundleProducts: castedState.bundleProducts,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: true,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      } else {
        final castedState = state as ProductDataLoadSuccess;
        emit(
          ProductInteractionSuccess(
            interactionType: ProductInteractionTypes.addToWishlist,
            dimensions: castedState.dimensions,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: true,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      }
      await _wishlistRepository.addProductToWishlist(
        productId: _productId,
        isBundle: isBundle,
      );
    } on WishlistRepositoryException catch (e) {
      if (isBundle) {
        final castedState = state as ProductBundleDataLoadSuccess;
        emit(
          ProductBundleInteractionFail(
            errorMessage: e.message,
            interactionType: ProductInteractionTypes.addToWishlist,
            descriptionParagraphs: castedState.descriptionParagraphs,
            bundleProducts: castedState.bundleProducts,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: false,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      } else {
        final castedState = state as ProductDataLoadSuccess;
        emit(
          ProductInteractionFail(
            errorMessage: e.message,
            interactionType: ProductInteractionTypes.addToWishlist,
            dimensions: castedState.dimensions,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: false,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      }
    }
  }

  FutureOr<void> _onProductRemovedFromWishlist(
    ProductRemovedFromWishlist event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (isBundle) {
        final castedState = state as ProductBundleDataLoadSuccess;
        emit(
          ProductBundleInteractionSuccess(
            interactionType: ProductInteractionTypes.removeFromWishlist,
            descriptionParagraphs: castedState.descriptionParagraphs,
            bundleProducts: castedState.bundleProducts,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: false,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      } else {
        final castedState = state as ProductDataLoadSuccess;
        emit(
          ProductInteractionSuccess(
            interactionType: ProductInteractionTypes.removeFromWishlist,
            dimensions: castedState.dimensions,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: false,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      }
      await _wishlistRepository.removeProductFromWishlist(
        productId: _productId,
        isBundle: isBundle,
      );
    } on WishlistRepositoryException catch (e) {
      if (isBundle) {
        final castedState = state as ProductBundleDataLoadSuccess;
        emit(
          ProductBundleInteractionFail(
            errorMessage: e.message,
            interactionType: ProductInteractionTypes.removeFromWishlist,
            descriptionParagraphs: castedState.descriptionParagraphs,
            bundleProducts: castedState.bundleProducts,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: true,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      } else {
        final castedState = state as ProductDataLoadSuccess;
        emit(
          ProductInteractionFail(
            errorMessage: e.message,
            interactionType: ProductInteractionTypes.removeFromWishlist,
            dimensions: castedState.dimensions,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: true,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      }
    }
  }

  FutureOr<void> _onProductAddedToCart(
    ProductAddedToCart event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await _cartRepository.addProductToCart(_productId,
          quantity: event.quantity,
          productAttributes: event.productAttributes,
          isBundle: isBundle);
      if (isBundle) {
        final castedState = state as ProductBundleDataLoadSuccess;
        emit(
          ProductBundleInteractionSuccess(
            interactionType: ProductInteractionTypes.addToCart,
            descriptionParagraphs: castedState.descriptionParagraphs,
            bundleProducts: castedState.bundleProducts,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: castedState.isWishlisted,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      } else {
        final castedState = state as ProductDataLoadSuccess;
        emit(
          ProductInteractionSuccess(
            interactionType: ProductInteractionTypes.addToCart,
            dimensions: castedState.dimensions,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: castedState.isWishlisted,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      }
    } on CartRepositoryException catch (e) {
      if (isBundle) {
        final castedState = state as ProductBundleDataLoadSuccess;
        emit(
          ProductBundleInteractionFail(
            errorMessage: e.message,
            interactionType: ProductInteractionTypes.removeFromWishlist,
            descriptionParagraphs: castedState.descriptionParagraphs,
            bundleProducts: castedState.bundleProducts,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: true,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      } else {
        final castedState = state as ProductDataLoadSuccess;
        emit(
          ProductInteractionFail(
            errorMessage: e.message,
            interactionType: ProductInteractionTypes.removeFromWishlist,
            dimensions: castedState.dimensions,
            productId: castedState.productId,
            imagesUrls: castedState.imagesUrls,
            stockStatus: castedState.stockStatus,
            price: castedState.price,
            priceBeforeDiscount: castedState.priceBeforeDiscount,
            isWishlisted: true,
            expectedDeliveryTime: castedState.expectedDeliveryTime,
            attributesOptions: castedState.attributesOptions,
            selectedAttributesOptions: castedState.selectedAttributesOptions,
            description: castedState.description,
            name: castedState.name,
          ),
        );
      }
    }
  }
}

// Events

abstract class ProductEvent {}

class ProductInitialized extends ProductEvent {}

class ProductAttributeOptionSelected extends ProductEvent {
  final String attributeLabel;
  final String attributeValue;

  ProductAttributeOptionSelected({
    required this.attributeLabel,
    required this.attributeValue,
  });
}

class ProductAddedToWishlist extends ProductEvent {}

class ProductRemovedFromWishlist extends ProductEvent {}

class ProductAddedToCart extends ProductEvent {
  final int quantity;
  final Map<String, String> productAttributes;

  ProductAddedToCart({
    required this.quantity,
    required this.productAttributes,
  });
}

// States

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductDataLoadInProgress extends ProductState {}

class ProductDataLoadFail extends ProductState {
  final String errorMessage;

  ProductDataLoadFail(this.errorMessage);
}

class ProductDataLoadSuccess extends ProductState {
  final String productId;
  final String name;
  final List<String> imagesUrls;
  final ProductStockStatus stockStatus;
  final int price;
  final int? priceBeforeDiscount;
  final bool isWishlisted;
  final ProductDeliveryTime expectedDeliveryTime;
  final Map<String, List<String>> attributesOptions;
  final Map<String, String> selectedAttributesOptions;
  final String description;
  final ProductDimensions dimensions;

  ProductDataLoadSuccess({
    required this.productId,
    required this.imagesUrls,
    required this.stockStatus,
    required this.price,
    required this.priceBeforeDiscount,
    required this.isWishlisted,
    required this.expectedDeliveryTime,
    required this.attributesOptions,
    required this.selectedAttributesOptions,
    required this.description,
    required this.dimensions,
    required this.name,
  });
}

class ProductInteractionSuccess extends ProductDataLoadSuccess {
  final ProductInteractionTypes interactionType;
  ProductInteractionSuccess({
    required this.interactionType,
    required super.productId,
    required super.imagesUrls,
    required super.stockStatus,
    required super.price,
    required super.priceBeforeDiscount,
    required super.isWishlisted,
    required super.expectedDeliveryTime,
    required super.attributesOptions,
    required super.selectedAttributesOptions,
    required super.description,
    required super.dimensions,
    required super.name,
  });
}

class ProductInteractionFail extends ProductDataLoadSuccess {
  final ProductInteractionTypes interactionType;
  final String errorMessage;

  ProductInteractionFail({
    required this.interactionType,
    required this.errorMessage,
    required super.productId,
    required super.imagesUrls,
    required super.stockStatus,
    required super.price,
    required super.priceBeforeDiscount,
    required super.isWishlisted,
    required super.expectedDeliveryTime,
    required super.attributesOptions,
    required super.selectedAttributesOptions,
    required super.description,
    required super.dimensions,
    required super.name,
  });
}

class ProductBundleDataLoadSuccess extends ProductDataLoadSuccess {
  final List<String> descriptionParagraphs;
  final List<ProductBrief> bundleProducts;
  ProductBundleDataLoadSuccess({
    required this.descriptionParagraphs,
    required this.bundleProducts,
    required super.productId,
    required super.imagesUrls,
    required super.stockStatus,
    required super.price,
    required super.priceBeforeDiscount,
    required super.isWishlisted,
    required super.expectedDeliveryTime,
    required super.attributesOptions,
    required super.selectedAttributesOptions,
    required super.description,
    required super.name,
  }) : super(
          dimensions: ProductDimensions(
            length: 0,
            width: 0,
            height: 0,
          ),
        );
}

class ProductBundleInteractionSuccess extends ProductBundleDataLoadSuccess {
  final ProductInteractionTypes interactionType;
  ProductBundleInteractionSuccess({
    required this.interactionType,
    required super.descriptionParagraphs,
    required super.bundleProducts,
    required super.productId,
    required super.imagesUrls,
    required super.stockStatus,
    required super.price,
    required super.priceBeforeDiscount,
    required super.isWishlisted,
    required super.expectedDeliveryTime,
    required super.attributesOptions,
    required super.selectedAttributesOptions,
    required super.description,
    required super.name,
  });
}

class ProductBundleInteractionFail extends ProductBundleDataLoadSuccess {
  final ProductInteractionTypes interactionType;
  final String errorMessage;
  ProductBundleInteractionFail({
    required this.interactionType,
    required this.errorMessage,
    required super.descriptionParagraphs,
    required super.bundleProducts,
    required super.productId,
    required super.imagesUrls,
    required super.stockStatus,
    required super.price,
    required super.priceBeforeDiscount,
    required super.isWishlisted,
    required super.expectedDeliveryTime,
    required super.attributesOptions,
    required super.selectedAttributesOptions,
    required super.description,
    required super.name,
  });
}

enum ProductInteractionTypes {
  addToWishlist,
  removeFromWishlist,
  addToCart,
  removeFromCart,
}
