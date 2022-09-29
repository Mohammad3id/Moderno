String formateEnum(Enum enumeratedValue) {
  String result = enumeratedValue.name[0].toUpperCase();
  if (enumeratedValue.name.length == 1) return result;

  for (final char in enumeratedValue.name.substring(1).split("")) {
    if (char.startsWith(RegExp("[A-Z]"))) {
      result += " ";
    }
    result += char;
  }
  return result;
}
