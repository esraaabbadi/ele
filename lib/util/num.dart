import 'package:flutter/services.dart';

class EnglishDigitFormatter extends TextInputFormatter {
  static const arabicDigits = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩'
  ];
  static const englishDigits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String converted = newValue.text;

    for (int i = 0; i < arabicDigits.length; i++) {
      converted = converted.replaceAll(arabicDigits[i], englishDigits[i]);
    }

    return TextEditingValue(
      text: converted,
      selection: newValue.selection,
    );
  }
}
