String keepNumbersOnly(String text, {bool withSpaces = false}) {
  var result = "";
  for (final char in text.split("")) {
    if (char.startsWith(RegExp("[0-9]")) ||
        withSpaces && char.startsWith(" ")) {
      result += char;
    }
  }
  return result;
}
