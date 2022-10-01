import 'calculate_color_value.dart';

int calculateContrast(String hexColor1, String hexColor2) {
  int result = 0;
  if (!hexColor1.startsWith("#") || !hexColor2.startsWith("#")) {
    throw InvalidColorFormatException("Invalid color format.");
  }

  result += (int.parse(hexColor1.substring(1, 3), radix: 16) -
          int.parse(hexColor2.substring(1, 3), radix: 16))
      .abs();
  result += (int.parse(hexColor1.substring(3, 5), radix: 16) -
          int.parse(hexColor2.substring(3, 5), radix: 16))
      .abs();
  result += (int.parse(hexColor1.substring(5), radix: 16) -
          int.parse(hexColor2.substring(5), radix: 16))
      .abs();

  return result;
}
