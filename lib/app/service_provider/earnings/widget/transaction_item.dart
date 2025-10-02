import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/earnings/view/withdrawal_details.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/functions.dart';
import '../../../../widget/textwidget.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transactionDetails,
  });
  final dynamic transactionDetails;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() =>
            TransactionDetailsScreen(transactionDetails: transactionDetails));
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.primaryCardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColor.whiteColor,
                    child: Icon(
                      transactionDetails["transactionType"] == "withdrawal" ||
                              transactionDetails["transactionType"] == "dr"
                          ? Icons.arrow_upward
                          : transactionDetails["transactionType"] == "payment"
                              ? Icons.arrow_downward
                              : transactionDetails["status"] == "pending"
                                  ? Icons.swap_vert
                                  : transactionDetails["status"] == "failed"
                                      ? Icons.close
                                      : Icons.arrow_upward,
                      color: transactionDetails["status"] == "success"
                          ? AppColor.primaryColor
                          : transactionDetails["status"] == "pending"
                              ? AppColor.yellowColor1
                              : AppColor.redColor1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: transactionDetails["transactionType"] ==
                                  "withdrawal"
                              ? transactionDetails["transactionType"]
                              : transactionDetails["transactionType"] == "dr"
                                  ? "Charges"
                                  : transactionDetails["senderName"],
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        TextWidget(
                          text: formatDate(transactionDetails["date"]),
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget(
                  text: transactionDetails["transactionType"] == "withdrawal" ||
                          transactionDetails["transactionType"] == "dr"
                      ? "-${formatAsMoney(
                          double.parse(transactionDetails["amount"].toString()),
                        )}"
                      : "+${formatAsMoney(
                          double.parse(transactionDetails["amount"].toString()),
                        )}",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blackColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
