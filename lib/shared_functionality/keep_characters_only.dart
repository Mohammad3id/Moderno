String keepCharactersOnly(String text, {bool withSpaces = false}) {
  var result = "";
  for (final char in text.split("")) {
    if (char.startsWith(RegExp("[a-z]")) ||
        char.startsWith(RegExp("[A-Z]")) ||
        withSpaces && char.startsWith(" ")) {
      result += char;
    }
  }
  return result;
}
