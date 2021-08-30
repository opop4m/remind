import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContextUtils {
  static TextEditingController buildTextEditingController(String value) {
    return TextEditingController.fromValue(TextEditingValue(
        text: value,
        // 保持光标在最后
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: value.length))));
  }
}

class StyleUtils {
  static final ButtonStyle btnStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
}
