import 'package:Victhon/app/service_provider/profile/view/create_transaction_pin.dart';
import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../widget/custom_snackbar.dart';
import '../../../../widget/loader.dart';
import '../view/withdrawal_successful.dart';

void showTransactionPinDialog(
  BuildContext context,
  int amount,
  String accountDetailsId,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return TransactionPinDialog(
        amount: amount,
        accountDetailsId: accountDetailsId,
      );
    },
  );
}

class TransactionPinDialog extends StatefulWidget {
  const TransactionPinDialog({
    super.key,
    required this.amount,
    required this.accountDetailsId,
  });
  final int amount;
  final String accountDetailsId;

  @override
  State<TransactionPinDialog> createState() => _TransactionPinDialogState();
}

class _TransactionPinDialogState extends State<TransactionPinDialog> {
  final List<String> pin = ['', '', '', ''];
  bool isLoading = false;
  // final earningsController = Get.put(EarningsController());

  void _onKeyPressed(String value) {
    setState(() {
      for (int i = 0; i < pin.length; i++) {
        if (pin[i].isEmpty) {
          pin[i] = value;

          // Check if all fields are now filled after assigning the current digit
          if (pin.every((digit) => digit.isNotEmpty)) {
            final enteredPin = pin.join();
            walletWithdrawal(
              widget.amount,
              enteredPin,
              widget.accountDetailsId,
              context,
            );
          }
          break;
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      for (int i = pin.length - 1; i >= 0; i--) {
        if (pin[i].isNotEmpty) {
          pin[i] = '';
          break;
        }
      }
    });
  }

  walletWithdrawal(
    int amount,
    String pin,
    String accountDetailsId,
    BuildContext context,
  ) async {
    isLoading = true;
    setState(() {});

    final ApiResponse response = await RemoteServices().walletWithdrawal(
        amount: amount, pin: pin, accountDetailsId: accountDetailsId);
    isLoading = false;
    setState(() {});

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      if (context.mounted) {
        Navigator.pop(context);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WithdrawalSuccessful(
                amount: amount,
              ),
            ));
      }
    } else if (response.errorMessage == "Transaction pin not set") {
      customSnackbar(
        "Alert",
        "Transaction pin not set",
        Colors.white.withOpacity(0.5),
      );
      if (context.mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateTransactionPin()));
      }
    } else {
      print("--------- ${response.statusCode}");

      print("--------- ${response.errorMessage}");
      if (context.mounted) {
        Navigator.pop(context);
      }

      isLoading = false;
      setState(() {});
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      customSnackbar("ERROR", errorMessage, Colors.orange);

      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40), // Spacer for alignment
                    const Text(
                      "Enter Transaction PIN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.primaryColor,
                          width: 1,
                        ),
                        color: AppColor.primaryCardColor,
                      ),
                      child: Text(
                        pin[index],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Forgot Transaction PIN?",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                buildKeypad(),
              ],
            ),
          ),
        ),
        isLoading ? const LoaderCircle() : const SizedBox(),
      ],
    );
  }

  Widget buildKeypad() {
    List<List<String>> keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['0'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            return buildKeyButton(key);
          }).toList()
            ..addIf(row.length == 1, buildBackspaceButton()),
        );
      }).toList(),
    );
  }

  Widget buildKeyButton(String number) {
    return GestureDetector(
      onTap: () => _onKeyPressed(number),
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 100,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.primaryCardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextWidget(
          text: number,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 100,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.primaryCardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.backspace, size: 24),
      ),
    );
  }
}

extension ListExtensions<E> on List<E> {
  void addIf(bool condition, E element) {
    if (condition) add(element);
  }
}
