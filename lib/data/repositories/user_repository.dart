import 'package:moderno/data/models/cart.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/models/user.dart';
import 'package:moderno/data/providers/user_provider.dart';
import 'package:moderno/data/repositories/shared/repository_exception.dart';

class UserRepository {
  static UserRepository instance = UserRepository();

  var _currentUser = User.guest;
  final _userProvider = UserProvider.instance;

  User get currentUser {
    return _currentUser;
  }

  Future<User> logIn(String email, String password) async {
    try {
      _currentUser = _buildUserFromDBUser(
        await _userProvider.logIn(email, password),
      );
      return _currentUser;
    } on UserDatabaseException catch (e) {
      throw UserRepositoryException(e.message);
    }
  }

  Future<User> logOut() async {
    _currentUser = User.guest;
    return _currentUser;
  }

  Future<User> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    List<Product>? wishlist,
    Cart? cart,
  }) async {
    try {
      _currentUser = _buildUserFromDBUser(
        await _userProvider.createUser(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
          wishlist: wishlist,
          cart: cart,
        ),
      );
      return _currentUser;
    } on UserDatabaseException catch (e) {
      throw UserRepositoryException(e.message);
    }
  }

  Future<User> addPaymentMethodToCurrentUser({
    required String cardHolderName,
    required String cardNumber,
    required String cardCVV,
    required int expiryMonth,
    required int expiryYear,
  }) async {
    if (!await isUserSignedIn()) {
      throw UserRepositoryException(
          "Can't add payment method to a guest user.");
    }
    try {
      _currentUser = _buildUserFromDBUser(
        await _userProvider.addPaymentMethodToDBUser(
          _currentUser.id,
          cardHolderName: cardHolderName,
          cardNumber: cardNumber,
          cardCVV: cardCVV,
          expiryMonth: expiryMonth,
          expiryYear: expiryYear,
        ),
      );
      return _currentUser;
    } on UserDatabaseException catch (e) {
      throw UserRepositoryException(e.message);
    }
  }

  Future<User> removePaymentMethodFromCurrentUser(cardNumber) async {
    if (!await isUserSignedIn()) {
      throw UserRepositoryException(
        "Can't remove payment method from a guest user.",
      );
    }
    try {
      _currentUser = _buildUserFromDBUser(
        await _userProvider.removePaymentMethodFromDBUser(
          _currentUser.id,
          cardNumber: cardNumber,
        ),
      );
      return _currentUser;
    } on UserDatabaseException catch (e) {
      throw UserRepositoryException(e.message);
    }
  }

  Future<User> updateCurrentUserInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? oldPassword,
    String? password,
  }) async {
    if (!await isUserSignedIn()) {
      throw UserRepositoryException("Can't update data of a guest user.");
    }
    try {
      _currentUser = _buildUserFromDBUser(
        await _userProvider.updateDBUser(
          _currentUser.id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          oldPassword: oldPassword,
          password: password,
        ),
      );
      return _currentUser;
    } on UserDatabaseException catch (e) {
      throw UserRepositoryException(e.message);
    }
  }

  Future<bool> isUserSignedIn() async {
    return _currentUser.id != "";
  }

  User _buildUserFromDBUser(DatabaseUser databaseUser) {
    try {
      return User(
        id: databaseUser.id,
        email: databaseUser.email,
        firstName: databaseUser.firstName,
        lastName: databaseUser.lastName,
        paymentMethods: databaseUser.paymentMethods,
        phoneNumber: databaseUser.phoneNumber,
        shippingAddresses: databaseUser.shippingAdresses,
        orders: databaseUser.orders,
      );
    } catch (e) {
      throw UserDatabaseException("Error creating a user: $e");
    }
  }
}

class UserRepositoryException extends RepositoryException {
  UserRepositoryException(super.message);
}
