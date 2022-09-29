import 'dart:math';

int calculateColorValue(String hexColor, [int opacity = 255]) {
  if (!hexColor.startsWith("#")) {
    throw InvalidColorFormatException("Invalid color format.");
  }

  return int.parse(hexColor.substring(1), radix: 16) +
      opacity * pow(16, 6).toInt();
}

class InvalidColorFormatException implements Exception {
  String message;
  InvalidColorFormatException(this.message);
}
