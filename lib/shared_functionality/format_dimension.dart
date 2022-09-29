import 'dart:math';

String formatDimension(int dimension) {
  if (dimension < 100) {
    return "${max(0, dimension)} cm";
  } else if (dimension % 100 == 0) {
    return "${(dimension ~/ 100)} m";
  } else {
    final strDimension = "$dimension";
    var temp =
        "${strDimension.substring(0, strDimension.length - 2)}.${strDimension.substring(strDimension.length - 2)}";
    if (temp[temp.length - 1] == "0") {
      temp = temp.substring(0, temp.length - 1);
    }
    return "$temp m";
  }
}
