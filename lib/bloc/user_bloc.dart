import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/models/user.dart';
import 'package:moderno/data/repositories/cart_repository.dart';
import 'package:moderno/data/repositories/user_repository.dart';
import 'package:moderno/data/repositories/wishlist_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _userRepository = UserRepository.instance;
  final _wishlistRepository = WishlistRepository.instance;
  final _cartRepository = CartRepository.instance;

  UserBloc() : super(UserInitial()) {
    on<UserInitialized>(_onUserInitialized);
    on<UserCreated>(_onUserCreated);
    on<UserLogedIn>(_onUserLogedIn);
    on<UserLogedOut>(_onUserLogedOut);
    on<UserInfoChanged>(_onUserInfoChanged);
    on<UserReloaded>(_onUserReloaded);
    on<UserPaymentMethodAdded>(_onUserPaymentMethodAdded);
    on<UserPaymentMethodRemoved>(_onUserPaymentMethodRemoved);
    on<UserShippingAddressAdded>(_onUserShippingAddressAdded);
    on<UserShippingAddressUpdated>(_onUserShippingAddressUpdated);
    on<UserShippingAddressRemoved>(_onUserShippingAddressRemoved);
    add(UserInitialized());
  }

  FutureOr<void> _onUserInitialized(
    UserInitialized event,
    Emitter<UserState> emit,
  ) async {
    if (await _userRepository.isUserSignedIn()) {
      _wishlistRepository.loadWishlist();
      _cartRepository.loadCart();
      emit(
        UserLoginSuccess(
          userInfo: _userRepository.currentUser,
          wishlist:
              _createProductsBriefsList(_wishlistRepository.currentWishlist),
        ),
      );
    } else {
      emit(UserGuest());
    }
  }

  FutureOr<void> _onUserCreated(
    UserCreated event,
    Emitter<UserState> emit,
  ) async {
    emit(UserCreationInProgress());
    try {
      await _userRepository.createAccount(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        cart: _cartRepository.currentCart,
        wishlist: _wishlistRepository.currentWishlist,
      );
      emit(UserLoginSuccess(
        userInfo: _userRepository.currentUser,
        wishlist:
            _createProductsBriefsList(_wishlistRepository.currentWishlist),
      ));
    } on UserRepositoryException catch (e) {
      emit(UserCreationFailed(e.message));
    }
  }

  FutureOr<void> _onUserLogedIn(
    UserLogedIn event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoginInProgress());
    try {
      await _userRepository.logIn(event.email, event.password);
      if (_wishlistRepository.currentWishlist.isNotEmpty) {
        final guestWishlist = _wishlistRepository.currentWishlist;
        await _wishlistRepository.loadWishlist();
        for (final product in guestWishlist) {
          if (!await _wishlistRepository.isProductWishlisted(product.id)) {
            await _wishlistRepository.addProductToWishlist(
              productId: product.id,
            );
          }
        }
      }
      if (_cartRepository.currentCart.items.isNotEmpty) {
        final guestCart = _cartRepository.currentCart;
        await _cartRepository.loadCart();
        for (final item in guestCart.items) {
          await _cartRepository.addProductToCart(
            item.product.id,
            quantity: item.quantity,
            productAttributes: item.productAttributes,
          );
        }
      }
      emit(UserLoginSuccess(
        userInfo: _userRepository.currentUser,
        wishlist:
            _createProductsBriefsList(_wishlistRepository.currentWishlist),
      ));
    } on UserRepositoryException catch (e) {
      emit(UserLoginFailed(e.message));
    }
  }

  FutureOr<void> _onUserLogedOut(
    UserLogedOut event,
    Emitter<UserState> emit,
  ) async {
    await _userRepository.logOut();
    await _cartRepository.clearCart();
    await _wishlistRepository.clearWishlist();
    emit(UserGuest());
  }

  FutureOr<void> _onUserInfoChanged(
    UserInfoChanged event,
    Emitter<UserState> emit,
  ) async {
    emit(UserUpdateInProgress(
      userInfo: _userRepository.currentUser,
      wishlist: _createProductsBriefsList(_wishlistRepository.currentWishlist),
    ));
    try {
      await _userRepository.updateCurrentUserInfo(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        oldPassword: event.oldPassword,
        password: event.password,
        phoneNumber: event.phoneNumber,
      );

      emit(UserUpdateSuccess(
        userInfo: _userRepository.currentUser,
        wishlist:
            _createProductsBriefsList(_wishlistRepository.currentWishlist),
      ));
    } on UserRepositoryException catch (e) {
      emit(UserUpdateFailed(
        errorMessage: e.message,
        userInfo: _userRepository.currentUser,
        wishlist: _createProductsBriefsList(
          _wishlistRepository.currentWishlist,
        ),
      ));
    }
  }

  FutureOr<void> _onUserReloaded(UserReloaded event, Emitter<UserState> emit) {
    if (state is UserLoginSuccess) {
      emit(
        UserLoginSuccess(
          userInfo: _userRepository.currentUser,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    }
  }

  List<ProductBrief> _createProductsBriefsList(List<Product> products) {
    return products
        .map(
          (product) => ProductBrief(
            id: product.id,
            imageUrl: product.imagesUrls.first,
            // Cause I don't want the hearts to appear in list of only wishlisted products
            isWishlisted: false,
            price: product.price,
            priceBeforDiscount: product.priceBeforeDiscount,
          ),
        )
        .toList();
  }

  FutureOr<void> _onUserPaymentMethodAdded(
      UserPaymentMethodAdded event, Emitter<UserState> emit) async {
    try {
      final user = await _userRepository.addPaymentMethodToCurrentUser(
        cardHolderName: event.cardHolderName,
        cardNumber: event.cardNumber,
        cardCVV: event.cardCVV,
        expiryMonth: event.expiryMonth,
        expiryYear: event.expiryYear,
      );
      emit(
        UserUpdateSuccess(
          userInfo: user,
          wishlist:
              _createProductsBriefsList(_wishlistRepository.currentWishlist),
        ),
      );
    } on UserRepositoryException catch (e) {
      emit(
        UserUpdateFailed(
          errorMessage: e.message,
          userInfo: _userRepository.currentUser,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUserPaymentMethodRemoved(
    UserPaymentMethodRemoved event,
    Emitter<UserState> emit,
  ) async {
    try {
      final user = await _userRepository
          .removePaymentMethodFromCurrentUser(event.cardNumber);
      emit(
        UserUpdateSuccess(
          userInfo: user,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    } catch (e) {
      emit(
        UserUpdateFailed(
          errorMessage: "Unknown error occured $e",
          userInfo: _userRepository.currentUser,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUserShippingAddressAdded(
      UserShippingAddressAdded event, Emitter<UserState> emit) async {
    try {
      final user = await _userRepository.addShippingAddressToCurrentUser(
        name: event.name,
        country: event.country,
        governate: event.governate,
        city: event.city,
        street: event.street,
        additionalAddressDetails: event.additionalAddressDetails,
        phoneNumber: event.phoneNumber,
      );

      emit(
        UserUpdateSuccess(
          userInfo: user,
          wishlist:
              _createProductsBriefsList(_wishlistRepository.currentWishlist),
        ),
      );
    } on UserRepositoryException catch (e) {
      emit(
        UserUpdateFailed(
          errorMessage: e.message,
          userInfo: _userRepository.currentUser,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUserShippingAddressUpdated(
    UserShippingAddressUpdated event,
    Emitter<UserState> emit,
  ) async {
    try {
      final user = await _userRepository.updateShippingAddressFromCurrentUser(
        shippingAddressId: event.id,
        name: event.name,
        country: event.country,
        governate: event.governate,
        city: event.city,
        street: event.street,
        additionalAddressDetails: event.additionalAddressDetails,
        phoneNumber: event.phoneNumber,
      );

      emit(
        UserUpdateSuccess(
          userInfo: user,
          wishlist:
              _createProductsBriefsList(_wishlistRepository.currentWishlist),
        ),
      );
    } on UserRepositoryException catch (e) {
      emit(
        UserUpdateFailed(
          errorMessage: e.message,
          userInfo: _userRepository.currentUser,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUserShippingAddressRemoved(
      UserShippingAddressRemoved event, Emitter<UserState> emit) async {
    try {
      final user =
          await _userRepository.removeShippingAddressFromCurrentUser(event.id);
      emit(
        UserUpdateSuccess(
          userInfo: user,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    } catch (e) {
      emit(
        UserUpdateFailed(
          errorMessage: "Unknown error occured $e",
          userInfo: _userRepository.currentUser,
          wishlist: _createProductsBriefsList(
            _wishlistRepository.currentWishlist,
          ),
        ),
      );
    }
  }
}

// Events
abstract class UserEvent {}

class UserInitialized extends UserEvent {}

class UserCreated extends UserEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  UserCreated({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class UserLogedIn extends UserEvent {
  final String email;
  final String password;

  UserLogedIn({
    required this.email,
    required this.password,
  });
}

class UserLogedOut extends UserEvent {}

class UserInfoChanged extends UserEvent {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? oldPassword;
  final String? password;

  UserInfoChanged({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.oldPassword,
    this.password,
  });
}

class UserPaymentMethodAdded extends UserEvent {
  final String cardHolderName;
  final String cardNumber;
  final String cardCVV;
  final int expiryMonth;
  final int expiryYear;
  UserPaymentMethodAdded({
    required this.cardHolderName,
    required this.cardNumber,
    required this.cardCVV,
    required this.expiryMonth,
    required this.expiryYear,
  });
}

class UserPaymentMethodRemoved extends UserEvent {
  final String cardNumber;
  UserPaymentMethodRemoved(
    this.cardNumber,
  );
}

class UserShippingAddressAdded extends UserEvent {
  final String name;
  final String country;
  final String governate;
  final String city;
  final String street;
  final String? additionalAddressDetails;
  final String phoneNumber;

  UserShippingAddressAdded({
    required this.country,
    required this.governate,
    required this.city,
    required this.street,
    required this.additionalAddressDetails,
    required this.name,
    required this.phoneNumber,
  });
}

class UserShippingAddressUpdated extends UserEvent {
  final String id;
  final String name;
  final String country;
  final String governate;
  final String city;
  final String street;
  final String? additionalAddressDetails;
  final String phoneNumber;

  UserShippingAddressUpdated({
    required this.id,
    required this.country,
    required this.governate,
    required this.city,
    required this.street,
    required this.additionalAddressDetails,
    required this.name,
    required this.phoneNumber,
  });
}

class UserShippingAddressRemoved extends UserEvent {
  final String id;

  UserShippingAddressRemoved(
    this.id,
  );
}

class UserReloaded extends UserEvent {}

// States
abstract class UserState {}

class UserInitial extends UserState {}

class UserGuest extends UserState {}

class UserErrorState extends UserState {
  final String errorMessage;
  UserErrorState(this.errorMessage);
}

class UserCreationFailed extends UserGuest implements UserErrorState {
  @override
  final String errorMessage;
  UserCreationFailed(this.errorMessage);
}

class UserLoginFailed extends UserGuest implements UserErrorState {
  @override
  final String errorMessage;
  UserLoginFailed(this.errorMessage);
}

class UserCreationInProgress extends UserState {}

class UserLoginInProgress extends UserState {}

class UserLoginSuccess extends UserState {
  final User userInfo;
  final List<ProductBrief> wishlist;

  UserLoginSuccess({
    required this.userInfo,
    required this.wishlist,
  });
}

class UserUpdateSuccess extends UserLoginSuccess {
  UserUpdateSuccess({required super.userInfo, required super.wishlist});
}

class UserUpdateInProgress extends UserLoginSuccess {
  UserUpdateInProgress({required super.userInfo, required super.wishlist});
}

class UserUpdateFailed extends UserLoginSuccess implements UserErrorState {
  @override
  final String errorMessage;
  UserUpdateFailed({
    required this.errorMessage,
    required super.userInfo,
    required super.wishlist,
  });
}
