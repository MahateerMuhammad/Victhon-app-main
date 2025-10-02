import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoneyInputController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final TextEditingController accountNumController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();

  final isFormFilled = false.obs;

  void updateWithdrawDetails() {
    isFormFilled.value = accountNumController.text.isNotEmpty &&
        accountNameController.text.isNotEmpty;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    accountNumController.addListener(updateWithdrawDetails);
    accountNameController.addListener(updateWithdrawDetails);
  }

  final RxBool isValid = false.obs;

  bool _isFormatting = false;

  void onValueChanged(String rawValue) {
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

    // Check withdrawal range: ₦5,000 to ₦100,000
    if (amount < 5000 || amount > 100000) {
      isValid.value = false;
    } else {
      isValid.value = true;
    }

    final formatted = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    ).format(amount);

    if (formatted == controller.text) return;

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
  }

  int parseMoneyToInt(String value) {
    final numericString = value.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(numericString) ?? 0;
  }
}
