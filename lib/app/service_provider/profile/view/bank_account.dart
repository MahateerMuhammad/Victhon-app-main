import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/profile/controller/bank_account_controller.dart';
import 'package:Victhon/app/service_provider/profile/view/add_bank_account.dart';
import 'package:Victhon/widget/app_outline_button.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';

class BankAccount extends StatelessWidget {
  BankAccount({super.key});

  final bankAccountController = Get.put(BankAccountController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              title: const TextWidget(
                text: 'Bank Account',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              centerTitle: true,
              backgroundColor: AppColor.whiteColor,
              surfaceTintColor: AppColor.whiteColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () {
                        if (bankAccountController.accountDetails.isEmpty) {
                          return const SizedBox(); // Show loader while fetching
                        } else {
                          // Horizontal List of Services
                          return ListView.builder(
                            itemCount:
                                bankAccountController.accountDetails.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final bankAccount =
                                  bankAccountController.accountDetails[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Container(
                                  width: double.infinity,
                                  // height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryCardColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            ),
                                            TextWidget(
                                              text:
                                                  bankAccount["accountNumber"],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            print("------------ got here");
                                            bankAccountController
                                                .deleteBankAccount(
                                                    bankAccount["_id"],
                                                    context);
                                          },
                                          child:
                                              // bankAccountController.isLoading.value
                                              //     ? const CircularProgressIndicator(
                                              //         color: AppColor.error,
                                              //       )
                                              //     :
                                              const TextWidget(
                                            text: "Remove Account",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.redColor1,
                                          ),
                                        ),
                                      ],
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
                      height: 16,
                    ),
                    AppOutlinedButton(
                      borderColor: AppColor.primaryColor,
                      textColor: AppColor.primaryColor,
                      buttonText: "Add New Bank Account",
                      onPressed: () {
                        Get.to(() => AddBankAccount())!.then((_) {
                          Get.find<BankAccountController>()
                              .fetchAccountDetails();
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            // bankAccount.isEmpty?
            // BankAccountEmpty():
          ),
          bankAccountController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
