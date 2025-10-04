import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/earnings/controller/earnings_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/earnings/view/transactions_list.dart';
import 'package:Victhon/app/service_provider/earnings/view/withdraw_earnings.dart';
import 'package:Victhon/app/service_provider/earnings/widget/transaction_item.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/utils/images.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';

class EarningsView extends StatelessWidget {
  EarningsView({super.key});

  final earningsController = Get.put(EarningsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        surfaceTintColor: AppColor.whiteColor,
        automaticallyImplyLeading: false,
        title: const TextWidget(
          text: 'Earnings',
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage(AppImages.walletBg),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            text: 'Available Balance',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          const SizedBox(height: 10),
                          TextWidget(
                            text: formatAsMoney(
                              double.parse(
                                earningsController.walletBalance.value
                                    .toString(),
                              ),
                            ),
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Image.asset(
                        AppIcons.walletIcon,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  AppPrimaryButton(
                    buttonText: "Withdraw",
                    onPressed: () {
                      Get.to(() => const WithdrawEarningsScreen());
                    },
                    buttonColor: AppColor.whiteColor,
                    textColor: AppColor.primaryColor.shade400,
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  text: 'Transactions',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                earningsController.transactionDetails.length > 5
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => TransactionsList(
                                transactions:
                                    earningsController.transactionDetails,
                              ));
                        },
                        child: const Row(
                          children: [
                            TextWidget(
                              text: 'View all',
                              color: AppColor.darkBlueColor,
                              fontSize: 14,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.darkBlueColor,
                              size: 16,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (earningsController.isLoading.isTrue) {
                return const Center(
                  child: TextWidget(
                    text: "Loading transactions... Please wait",
                  ),
                );
              } else {
                if (earningsController.transactionDetails.isEmpty) {
                  return const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: TextWidget(
                            text: "No transactions yet",
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount:
                            earningsController.transactionDetails.length > 5
                                ? 5
                                : earningsController.transactionDetails.length,
                        itemBuilder: (context, index) {
                          return TransactionItem(
                            transactionDetails:
                                earningsController.transactionDetails[index],
                          );
                        }),
                  );
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
