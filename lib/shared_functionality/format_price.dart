String formatPrice(int price) {
  String result = "";
  int commasCount = 0;
  for (final digit in price.toString().split("").reversed) {
    result = digit + result;
    if ((result.length - commasCount) % 3 == 0) {
      result = ",$result";
      commasCount += 1;
    }
  }
  if (result[0] == ",") {
    return result.substring(1);
  }
  return result;
}
