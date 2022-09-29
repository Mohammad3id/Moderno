import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/models/order.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/models/user.dart';
import 'package:moderno/data/providers/shared/database_exception.dart';
import 'package:uuid/uuid.dart';

import 'product_provider.dart';

class UserProvider {
  static UserProvider instance = UserProvider();

  final _usersDB = _loadUsersDatabase();

  Future<DatabaseUser> logIn(String email, String password) async {
    try {
      return _usersDB.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (_) {
      throw UserDatabaseException("Incorrect email or password");
    }
  }

  Future<DatabaseUser> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    List<Product>? wishlist,
    Cart? cart,
  }) async {
    if (_usersDB.any((user) => user.email == email)) {
      throw UserDatabaseException("Email already used");
    }

    var newUser = DatabaseUser(
      password: password,
      id: const Uuid().v4(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      shippingAdresses: [],
      paymentMethods: [],
      orders: [],
      wishlist: wishlist ?? [],
      cart: cart ?? Cart([]),
    );

    _usersDB.add(newUser);

    return newUser;
  }

  Future<DatabaseUser> addPaymentMethodToDBUser(
    String userId, {
    required String cardHolderName,
    required String cardNumber,
    required String cardCVV,
    required int expiryMonth,
    required int expiryYear,
  }) async {
    final databaseUser = await getUserById(userId);

    if (databaseUser.paymentMethods
        .any((paymentMethod) => paymentMethod.cardNumber == cardNumber)) {
      throw DatabaseException(
          "Payment method with the same card number is already registered");
    }

    try {
      databaseUser.paymentMethods.add(
        UserPaymentMethod(
          cardNumber: cardNumber,
          cardHolderName: cardHolderName,
          cvv: cardCVV,
          expiryMonth: expiryMonth,
          expiryYear: expiryYear,
        ),
      );
      return databaseUser;
    } on UserException catch (e) {
      throw UserDatabaseException(
          "Invalid payment method details: ${e.message}");
    }
  }

  Future<DatabaseUser> removePaymentMethodFromDBUser(
    String userId, {
    required String cardNumber,
  }) async {
    final databaseUser = await getUserById(userId);
    databaseUser.paymentMethods.removeWhere(
      (paymentMethod) => paymentMethod.cardNumber == cardNumber,
    );
    return databaseUser;
  }

  Future<DatabaseUser> updateDBUser(
    String userId, {
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? oldPassword,
    String? password,
  }) async {
    if (password != null && password.length < 8) {
      throw UserDatabaseException(
        "Password should be at least 8 characters long",
      );
    }

    if (email != null &&
        _usersDB.any((user) => user.id != userId && user.email == email)) {
      throw UserDatabaseException("Email already used");
    }

    if (phoneNumber != null &&
        _usersDB.any(
            (user) => user.id != userId && user.phoneNumber == phoneNumber)) {
      throw UserDatabaseException("Phone number already used");
    }

    final databaseUser = await getUserById(userId);

    if (password != null) {
      if (oldPassword == null) {
        throw UserDatabaseException(
            "Can't change password without providing the old password");
      }
      if (oldPassword != databaseUser.password) {
        throw UserDatabaseException("Incorrect password");
      }
    }

    databaseUser.firstName = firstName ?? databaseUser.firstName;
    databaseUser.lastName = lastName ?? databaseUser.lastName;
    databaseUser.email = email ?? databaseUser.email;
    databaseUser.phoneNumber = phoneNumber ?? databaseUser.phoneNumber;
    databaseUser.password = password ?? databaseUser.password;

    return databaseUser;
  }

  Future<DatabaseUser> removeProductFromWishlist(
    String userId,
    String productId,
  ) async {
    final databaseUser = await getUserById(userId);
    databaseUser.wishlist
        .removeWhere((wishlistProduct) => wishlistProduct.id == productId);
    return databaseUser;
  }

  Future<bool> isProductWishlisted(String userId, String productId) async {
    final databaseUser = await getUserById(userId);
    return databaseUser.wishlist
        .any((wishlistProduct) => wishlistProduct.id == productId);
  }

  Future<DatabaseUser> getUserById(String id) async {
    try {
      return _usersDB.firstWhere(
        (databaseUser) => databaseUser.id == id,
      );
    } catch (_) {
      throw UserDatabaseException("User doesn't exist");
    }
  }
}

class UserDatabaseException extends DatabaseException {
  UserDatabaseException(super.message);
}

class DatabaseUser {
  final String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String? phoneNumber;
  final List<UserShippingAddress> shippingAdresses;
  final List<UserPaymentMethod> paymentMethods;
  final List<Order> orders;
  final List<Product> wishlist;
  Cart cart;

  DatabaseUser({
    required this.password,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.shippingAdresses,
    required this.paymentMethods,
    required this.orders,
    required this.wishlist,
    required this.cart,
  });
}

List<DatabaseUser> usersDatabase = [
  DatabaseUser(
    password: "12345678",
    id: const Uuid().v4(),
    firstName: "Mohammad",
    lastName: "Eid",
    email: "eid115599@gmail.com",
    shippingAdresses: [
      UserShippingAddress(
        name: "Mohammad Mossad Eid",
        phoneNumber: "01028540384",
        country: "Egypt",
        state: "Damietta",
        city: "Dumyat City",
        street: "Elharby St.",
        additionalAddressDetails: "Near Alzaharaa Mosque",
      ),
    ],
    paymentMethods: [
      UserPaymentMethod(
        cardNumber: "5325513189716060",
        cardHolderName: "MOHAMMAD MOSSAD EID",
        cvv: "123",
        expiryMonth: 06,
        expiryYear: 2023,
      ),
      UserPaymentMethod(
        cardNumber: "4548776342037211",
        cardHolderName: "Ezzat MOSSAD EID",
        cvv: "123",
        expiryMonth: 02,
        expiryYear: 2026,
      ),
    ],
    orders: [
      Order(
        id: const Uuid().v4(),
        cart: Cart([
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[0],
            quantity: 1,
            productAttributes: productsDatabase[0].defaultAttributesOptions,
          ),
        ]),
        orderDate: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
        status: OrderStatus.onTheWay,
        deliveryDate: DateTime.now().add(
          const Duration(hours: 1),
        ),
      ),
      Order(
        id: const Uuid().v4(),
        cart: Cart([
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[0],
            quantity: 1,
            productAttributes: productsDatabase[0].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[1],
            quantity: 2,
            productAttributes: productsDatabase[1].defaultAttributesOptions,
          ),
        ]),
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.onTheWay,
        deliveryDate: DateTime.now().add(
          const Duration(days: 1),
        ),
      ),
      Order(
        id: const Uuid().v4(),
        cart: Cart([
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[0],
            quantity: 1,
            productAttributes: productsDatabase[0].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[1],
            quantity: 2,
            productAttributes: productsDatabase[1].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[2],
            quantity: 3,
            productAttributes: productsDatabase[2].defaultAttributesOptions,
          ),
        ]),
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        status: OrderStatus.onTheWay,
        deliveryDate: DateTime.now().add(
          const Duration(days: 5),
        ),
      ),
      Order(
        id: const Uuid().v4(),
        cart: Cart([
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[0],
            quantity: 1,
            productAttributes: productsDatabase[0].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[1],
            quantity: 2,
            productAttributes: productsDatabase[1].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[2],
            quantity: 3,
            productAttributes: productsDatabase[2].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[3],
            quantity: 4,
            productAttributes: productsDatabase[3].defaultAttributesOptions,
          ),
        ]),
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        status: OrderStatus.processing,
        deliveryDate: DateTime.now().subtract(
          const Duration(days: 2),
        ),
      ),
      Order(
        id: const Uuid().v4(),
        cart: Cart([
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[0],
            quantity: 1,
            productAttributes: productsDatabase[0].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[1],
            quantity: 2,
            productAttributes: productsDatabase[1].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[2],
            quantity: 3,
            productAttributes: productsDatabase[2].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[3],
            quantity: 4,
            productAttributes: productsDatabase[3].defaultAttributesOptions,
          ),
          CartItem(
            id: const Uuid().v4(),
            product: productsDatabase[3],
            quantity: 5,
            productAttributes: productsDatabase[3].defaultAttributesOptions,
          ),
        ]),
        orderDate: DateTime.now().subtract(const Duration(days: 9)),
        status: OrderStatus.deliverd,
        deliveryDate: DateTime.now().subtract(
          const Duration(days: 3),
        ),
      ),
    ],
    wishlist: [],
    cart: Cart([]),
  ),
];

List<DatabaseUser> _loadUsersDatabase() {
  return usersDatabase;
}
