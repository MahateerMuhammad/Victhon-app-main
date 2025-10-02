import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/earnings/widget/transaction_item.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    required this.transactions,
  });

  final List transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.blackColor),
          onPressed: () => Get.back(),
        ),
        title: const TextWidget(
          text: "Transactions",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColor.blackColor,
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.history,
              size: 18,
              color: AppColor.blueColor,
            ),
            label: const Text(
              "Filter",
              style: TextStyle(
                color: AppColor.blueColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return TransactionItem(
              transactionDetails: transactions[index],
            );
          }),
    );
  }
}
