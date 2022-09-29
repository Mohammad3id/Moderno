import 'package:moderno/data/models/order.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final List<UserShippingAddress> shippingAddresses;
  final List<UserPaymentMethod> paymentMethods;
  final List<Order> orders;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.shippingAddresses,
    required this.paymentMethods,
    required this.orders,
  });

  static final guest = User(
    id: "",
    firstName: "",
    lastName: "",
    email: "",
    paymentMethods: [],
    shippingAddresses: [],
    orders: [],
  );
}

class UserShippingAddress {
  final String name;
  final String country;
  final String state;
  final String city;
  final String street;
  final String additionalAddressDetails;
  final String phoneNumber;

  UserShippingAddress({
    required this.country,
    required this.state,
    required this.city,
    required this.street,
    required this.additionalAddressDetails,
    required this.name,
    required this.phoneNumber,
  });
}

class UserPaymentMethod {
  late final String issuingNetwork;
  final String cardNumber;
  final String cardHolderName;
  final String cvv;
  final int expiryMonth;
  final int expiryYear;

  UserPaymentMethod({
    required this.cardNumber,
    required this.cardHolderName,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
  }) {
    if (cardNumber[0] == "4" && cardNumber.length == 16) {
      issuingNetwork = "Visa";
    } else if (int.parse(cardNumber.substring(0, 4)) >= 2221 &&
            int.parse(cardNumber.substring(0, 4)) <= 2720 ||
        int.parse(cardNumber.substring(0, 2)) >= 51 &&
            int.parse(cardNumber.substring(0, 2)) <= 55) {
      issuingNetwork = "MasterCard";
    } else {
      throw UserException("Invalid card number");
    }

    if (expiryMonth < 1 || expiryMonth > 12) {
      throw UserException("Invalid card expiry month");
    }
  }
}

class UserException implements Exception {
  final String message;
  UserException(this.message);
}
