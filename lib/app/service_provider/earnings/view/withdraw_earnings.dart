import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../utils/icons.dart';
import '../../../../widget/custom_form_field.dart';
import '../../createProfile/widget/bank_name_dialog.dart';
import '../../profile/controller/bank_account_controller.dart';
import '../controller/money_input_controller.dart';
import '../widget/show_transaction_pin_dialog.dart';

class WithdrawEarningsScreen extends StatefulWidget {
  const WithdrawEarningsScreen({super.key});

  @override
  _WithdrawEarningsScreenState createState() => _WithdrawEarningsScreenState();
}

class _WithdrawEarningsScreenState extends State<WithdrawEarningsScreen> {
  // String? selectedBank;
  // TextEditingController accountNumberController = TextEditingController();
  // TextEditingController accountNameController = TextEditingController();
  final moneyController = Get.put(MoneyInputController());
  final bankAccountController = Get.put(BankAccountController());

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const TextWidget(
          text: 'Withdraw Earnings',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Withdrawal Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return TextField(
                controller: moneyController.controller,
                keyboardType: TextInputType.number,
                cursorHeight: 30,
                style: const TextStyle(
                  fontSize: 32,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: moneyController.onValueChanged,
                decoration: InputDecoration(
                  hintText: '₦0.00',
                  hintStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.primaryColor.shade50,
                      width: 2,
                    ),
                  ),
                  errorText: moneyController.isValid.value
                      ? null
                      : 'Amount must be within range',
                ),
              );
            }),
            const SizedBox(height: 10),

            RichText(
              text: const TextSpan(
                text: 'Cash withdrawal range: ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '₦5,000.00 - ₦100,000',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () {
                if (bankAccountController.accountDetails.isEmpty) {
                  return const SizedBox(); // Show loader while fetching
                } else {
                  // Horizontal List of Services
                  return ListView.builder(
                    itemCount: bankAccountController.accountDetails.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final bankAccount =
                          bankAccountController.accountDetails[index];
                      return GestureDetector(
                        onTap: () {
                          bankAccountController.selectedBankId.value =
                              bankAccount["_id"];
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            width: double.infinity,
                            // height: 100,
                            decoration: BoxDecoration(
                              color: bankAccount["_id"] ==
                                      bankAccountController.selectedBankId.value
                                  ? AppColor.primaryColor
                                  : AppColor.primaryCardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey.shade300,
                                    child: TextWidget(
                                      text: bankAccount["bankName"]
                                          .toString()
                                          .substring(0, 1),
                                    ),
                                    // backgroundImage: CachedNetworkImageProvider(
                                    //   bankAccount["bank"]["bankLogo"],
                                    //   errorListener: (error) => const Icon(
                                    //     Icons.person,
                                    //     color: AppColor.whiteColor,
                                    //   ),
                                    // ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: bankAccount["bankName"],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: bankAccount["_id"] ==
                                                bankAccountController
                                                    .selectedBankId.value
                                            ? AppColor.whiteColor
                                            : AppColor.blackColor,
                                      ),
                                      TextWidget(
                                        text: bankAccount["accountNumber"],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: bankAccount["_id"] ==
                                                bankAccountController
                                                    .selectedBankId.value
                                            ? AppColor.whiteColor
                                            : AppColor.blackColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(
              height: 40,
            ),

            // const Text(
            //   'Bank Name',
            //   style: TextStyle(
            //     fontSize: 14,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // BankNameTextfield(),
            // const SizedBox(height: 16),
            // const Text(
            //   'Account Number',
            //   style: TextStyle(
            //     fontSize: 14,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // CustomFormField(
            //   controller: moneyController.accountNumController,
            //   hintText: "Please Enter",
            //   maxLength: 10,
            //   keyboardType: TextInputType.number,
            // ),
            // const SizedBox(height: 16),
            // const Text(
            //   'Account Name',
            //   style: TextStyle(
            //     fontSize: 14,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // CustomFormField(
            //   controller: moneyController.accountNameController,
            //   hintText: "Please Enter",
            // ),
            // const SizedBox(height: 24),
            Obx(
              () => AppPrimaryButton(
                buttonText: "Withdraw",
                buttonColor:
                    bankAccountController.selectedBankId.value.isNotEmpty &&
                            moneyController.isValid.value
                        ? AppColor.primaryColor
                        : AppColor.primaryColor.shade200,
                onPressed: bankAccountController
                            .selectedBankId.value.isNotEmpty &&
                        moneyController.isValid.value
                    ? () {
                        int amount = moneyController
                            .parseMoneyToInt(moneyController.controller.text);
                        print("------------- $amount");
                        showTransactionPinDialog(
                          context,
                          amount,
                          bankAccountController.selectedBankId.value,
                        );
                        // showWithdrawDialog(context);
                      }
                    : () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
