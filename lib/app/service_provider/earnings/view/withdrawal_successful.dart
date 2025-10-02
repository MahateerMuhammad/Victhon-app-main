import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';

class WithdrawalSuccessful extends StatelessWidget {
  const WithdrawalSuccessful({
    super.key,
    required this.amount,
  });
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: const TextWidget(
                text: "Done",
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppIcons.checkMarkBadge,
              scale: 4,
            ),
            SizedBox(height: 10),
            Text(
              'Withdrawal Successful',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              formatAsMoney(double.parse(amount.toString())),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _transactionDetailRow(
                    'Bank Name',
                    Row(
                      children: [
                        Image.asset(AppIcons.bankLogo, width: 20),
                        SizedBox(width: 5),
                        Text('Guaranty Trust Bank'),
                      ],
                    )),
                _transactionDetailRow('Account Number', '0123456789'),
                _transactionDetailRow('Account Name', 'Olamide Oladehinde'),
                _transactionDetailRow('Transaction Type', 'Withdrawal'),
                _transactionDetailRow('Date', 'Jan 10, 2025, 2:00 PM'),
                _transactionDetailRow('Amount', '₦100,000'),
                _transactionDetailRow('Service Fee', '₦1000'),
                const SizedBox(height: 48),
              ],
            ),
            // Spacer(),
            Row(
              children: [
                Expanded(
                    child: AppOutlinedButton(
                  buttonText: "Save Account",
                  onPressed: () {},
                  borderColor: AppColor.primaryColor,
                  textColor: AppColor.primaryColor,
                )),
                SizedBox(width: 10),
                Expanded(
                    child: AppOutlinedButton(
                  buttonText: "Share Receipt",
                  onPressed: () {},
                  borderColor: AppColor.primaryColor,
                  textColor: AppColor.primaryColor,
                )),
              ],
            ),
            SizedBox(height: 24),
            AppPrimaryButton(
              onPressed: () {},
              buttonText: "View Details",
            )
          ],
        ),
      ),
    );
  }

  Widget _transactionDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
            fontSize: 14,
            color: Colors.grey,
          ),
          if (value is String)
            TextWidget(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )
          else
            value,
        ],
      ),
    );
  }
}
