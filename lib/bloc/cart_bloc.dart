import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/repositories/cart_repository.dart';
import 'package:moderno/data/repositories/shared/repository_exception.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final _cartRepository = CartRepository.instance;
  CartBloc() : super(CartInitial()) {
    on<CartInitialized>(_onCartInitialized);
    on<CartReloaded>(_onCartReloaded);
    on<CartItemQuantityIncreased>(_onCartItemQuantityIncreased);
    on<CartItemQuantityDecreased>(_onCartItemQuantityDecreased);
    on<CartProductAdded>(_onCartProductAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    add(CartInitialized());
  }

  FutureOr<void> _onCartInitialized(
    CartInitialized event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoadInProgress());
    await _cartRepository.loadCart();
    _tryEmitCartState(emit);
  }

  FutureOr<void> _onCartReloaded(CartReloaded event, Emitter<CartState> emit) {
    emit(CartLoadInProgress());
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _tryEmitCartState(emit);
    });
  }

  FutureOr<void> _onCartItemQuantityIncreased(
    CartItemQuantityIncreased event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.increaseCartItemQuantitiy(event.cartItemId);
    } on RepositoryException catch (e) {
      _emitCartInteractionFaild(emit, e.message);
    }

    _emitCartInteractionSucess(emit);
  }

  FutureOr<void> _onCartItemQuantityDecreased(
    CartItemQuantityDecreased event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.decreaseCartItemQuantitiy(event.cartItemId);
    } on RepositoryException catch (e) {
      _emitCartInteractionFaild(emit, e.message);
    }

    _emitCartInteractionSucess(emit);
  }

  FutureOr<void> _onCartProductAdded(
    CartProductAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.addProductToCart(
        event.productId,
        quantity: event.quantity,
        productAttributes: event.productAttributes,
      );
    } on RepositoryException catch (e) {
      _emitCartInteractionFaild(emit, e.message);
    }

    _tryEmitCartState(emit);
  }

  FutureOr<void> _onCartItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.decreaseCartItemQuantitiy(event.cartItemId);
    } on RepositoryException catch (e) {
      _emitCartInteractionFaild(emit, e.message);
    }

    _emitCartInteractionSucess(emit);
  }

  void _tryEmitCartState(Emitter<CartState> emit) {
    try {
      emit(CartLoadSuccess(
        cartItems: _cartRepository.currentCart.items,
        total: _cartRepository.currentCart.total,
        totalBeforeDiscount: _cartRepository.currentCart.totalBeforeDiscount,
      ));
    } on RepositoryException catch (e) {
      emit(CartLoadFail(e.message));
    }
  }

  void _emitCartInteractionSucess(Emitter<CartState> emit) {
    emit(CartInteractionSucess(
      cartItems: _cartRepository.currentCart.items,
      total: _cartRepository.currentCart.total,
      totalBeforeDiscount: _cartRepository.currentCart.totalBeforeDiscount,
    ));
  }

  void _emitCartInteractionFaild(Emitter<CartState> emit, String errorMessage) {
    emit(CartInteractionFail(
      errorMessage,
      cartItems: _cartRepository.currentCart.items,
      total: _cartRepository.currentCart.total,
      totalBeforeDiscount: _cartRepository.currentCart.totalBeforeDiscount,
    ));
  }
}

// Events
abstract class CartEvent {}

class CartInitialized extends CartEvent {}

class CartReloaded extends CartEvent {}

class CartItemQuantityIncreased extends CartEvent {
  final String cartItemId;

  CartItemQuantityIncreased(this.cartItemId);
}

class CartItemQuantityDecreased extends CartEvent {
  final String cartItemId;

  CartItemQuantityDecreased(this.cartItemId);
}

class CartProductAdded extends CartEvent {
  final String productId;
  final int quantity;
  final Map<String, String> productAttributes;

  CartProductAdded({
    required this.productId,
    required this.quantity,
    required this.productAttributes,
  });
}

class CartItemRemoved extends CartEvent {
  final String cartItemId;

  CartItemRemoved(this.cartItemId);
}

// States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoadInProgress extends CartState {}

class CartLoadFail extends CartState {
  final String errorMessage;

  CartLoadFail(this.errorMessage);
}

class CartLoadSuccess extends CartState {
  final List<CartItem> cartItems;
  final int total;
  final int? totalBeforeDiscount;

  CartLoadSuccess({
    required this.cartItems,
    required this.total,
    this.totalBeforeDiscount,
  });
}

class CartInteractionFail extends CartLoadSuccess {
  final String erorrMessage;

  CartInteractionFail(
    this.erorrMessage, {
    required super.cartItems,
    required super.total,
    super.totalBeforeDiscount,
  });
}

class CartInteractionSucess extends CartLoadSuccess {
  CartInteractionSucess({
    required super.cartItems,
    required super.total,
    super.totalBeforeDiscount,
  });
}
