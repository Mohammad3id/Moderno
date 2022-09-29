import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/repositories/wishlist_repository.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final _wishlistRepository = WishlistRepository.instance;
  WishlistBloc() : super(WishlistInitial()) {
    on<WishlistInitialized>(_onWishlistInitialized);
    add(WishlistInitialized());
  }

  FutureOr<void> _onWishlistInitialized(
    WishlistInitialized event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoadInProgress());
    try {
      final List<ProductInfo> wishlist =
          (await _wishlistRepository.loadWishlist())
              .map(
                (product) => ProductInfo(
                  id: product.id,
                  name: product.name,
                  stockStatus: product.stockStatus,
                  imageUrl: product.imagesUrls.first,
                  isWishlisted: true,
                  price: product.price,
                  isBundle: product is Bundle,
                  priceBeforeDiscount: product.priceBeforeDiscount,
                ),
              )
              .toList();

      emit(WishlistLoadSucess(wishlist));
    } on WishlistRepositoryException catch (e) {
      emit(WishlistLoadFailed(e.message));
    }
  }
}

// Events
abstract class WishlistEvent {}

class WishlistInitialized extends WishlistEvent {}

// States
abstract class WishlistState {
  final List<ProductInfo> wishlist;
  WishlistState(this.wishlist);
}

class WishlistInitial extends WishlistState {
  WishlistInitial() : super([]);
}

class WishlistLoadInProgress extends WishlistState {
  WishlistLoadInProgress() : super([]);
}

class WishlistLoadFailed extends WishlistState {
  final String errorMessage;
  WishlistLoadFailed(this.errorMessage) : super([]);
}

class WishlistLoadSucess extends WishlistState {
  WishlistLoadSucess(super.wishlist);
}
