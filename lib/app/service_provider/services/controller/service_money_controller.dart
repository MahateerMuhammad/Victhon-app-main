import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServiceMoneyController extends GetxController {
  final TextEditingController servicePricecontroller = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();

  final RxBool isValid = false.obs;

  bool _isFormatting = false;


  void onValueChanged(TextEditingController controller, String rawValue) {
  if (_isFormatting) return;

  final cleaned = rawValue.replaceAll(RegExp(r'[^\d]'), '');
  if (cleaned.isEmpty) {
    isValid.value = false;
    return;
  }

  final amount = double.tryParse(cleaned);
  if (amount == null) {
    isValid.value = false;
    return;
  }

  final formatted = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 0,
  ).format(amount);

  if (formatted == controller.text) {
    isValid.value = amount >= 1000;
    return;
  }

  final oldText = controller.text;
  final oldSelection = controller.selection.baseOffset;

  _isFormatting = true;

  controller.value = TextEditingValue(
    text: formatted,
    selection: TextSelection.collapsed(
      offset: formatted.length - (oldText.length - oldSelection),
    ),
  );

  _isFormatting = false;
  isValid.value = amount >= 1000;
}

  int parseMoneyToInt(String value) {
  final numericString = value.replaceAll(RegExp(r'[^\d]'), '');
  return int.tryParse(numericString) ?? 0;
}

}
