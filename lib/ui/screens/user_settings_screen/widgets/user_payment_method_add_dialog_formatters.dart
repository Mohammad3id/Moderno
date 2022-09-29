import 'package:flutter/services.dart';
import 'package:moderno/shared_functionality/keep_characters_only.dart';
import 'package:moderno/shared_functionality/keep_numbers_only.dart';

class CardHolderNameFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    if (oldValue.text.isNotEmpty &&
        newValue.text.compareTo(
                oldValue.text.substring(0, oldValue.text.length - 1)) ==
            0) {
      return newValue;
    }

    final result = keepCharactersOnly(newValue.text, withSpaces: true);
    return newValue.copyWith(
      text: result,
      selection: TextSelection.fromPosition(
        TextPosition(offset: result.length),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    if (oldValue.text.isNotEmpty &&
        newValue.text.compareTo(
                oldValue.text.substring(0, oldValue.text.length - 1)) ==
            0) {
      return newValue;
    }

    final result = keepNumbersOnly(newValue.text);
    return oldValue.copyWith(
      text: result,
      selection: TextSelection.fromPosition(
        TextPosition(offset: result.length),
      ),
    );
  }
}

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    if (newValue.selection.base.offset != newValue.text.length) {
      return oldValue.copyWith(
        selection: TextSelection.fromPosition(
          TextPosition(offset: oldValue.text.length),
        ),
      );
    }

    if (oldValue.text.isNotEmpty &&
        newValue.text.compareTo(
                oldValue.text.substring(0, oldValue.text.length - 1)) ==
            0) {
      return newValue;
    }

    var result = "";
    result = keepNumbersOnly(newValue.text);
    if (result.length == 1) {
      if (int.parse(result) > 1) {
        result = "0${result[0]}/";
      }
    } else if (result.length == 2) {
      if (int.parse(result) > 12) {
        result = "0${result[0]}/${result[1]}";
      } else {
        result += "/";
      }
    } else if (result.length > 2 && result.length <= 4) {
      result = "${result.substring(0, 2)}/${result.substring(2)}";
    } else if (result.length > 4) {
      result = "${result.substring(0, 2)}/${result.substring(2, 4)}";
    }

    return newValue.copyWith(
      text: result,
      selection: TextSelection.fromPosition(
        TextPosition(offset: result.length),
      ),
    );
  }
}
