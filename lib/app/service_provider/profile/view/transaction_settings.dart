import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:Victhon/app/service_provider/profile/view/create_transaction_pin.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class TransactionSettings extends StatefulWidget {
  const TransactionSettings({super.key});

  @override
  State<TransactionSettings> createState() => _TransactionSettingsState();
}

class _TransactionSettingsState extends State<TransactionSettings> {
  bool useBiometric = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const TextWidget(
          text: 'Transaction Setting',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.primaryCardColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(LucideIcons.key,
                          color: AppColor.primaryColor),
                      title: const Text(
                        "Create PIN",
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColor.blackColor.withOpacity(0.8),
                      ),
                      onTap: () {
                        Get.to(() => CreateTransactionPin());
                      }, // Implement navigation here
                    ),
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.lock,
                        // color: AppColor.primaryColor,
                        color: AppColor.blackColor.withOpacity(0.2),
                      ),
                      title: TextWidget(
                        text: "Forgot PIN",
                        fontSize: 16,
                        color: AppColor.blackColor.withOpacity(0.2),

                        // fontWeight: FontWeight.w300,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        // color: AppColor.blackColor.withOpacity(0.8),
                        color: AppColor.blackColor.withOpacity(0.2),
                      ),
                      onTap: () {
                        // Get.to(() => ForgotTransactionPin());
                      }, // Implement navigation here
                    ),
                    ListTile(
                      leading: Icon(
                        LucideIcons.fingerprint,
                        // color: AppColor.primaryColor,
                        color: AppColor.blackColor.withOpacity(0.2),
                      ),
                      title: TextWidget(
                        text: "Use Biometric",
                        fontSize: 16,
                        color: AppColor.blackColor.withOpacity(0.2),
                      ),
                      // trailing: SizedBox(
                      //   height: 35,
                      //   width: 45,
                      //   child: FittedBox(
                      //     fit: BoxFit.fill,
                      //     child: Switch(
                      //       value: useBiometric,
                      //       activeColor: AppColor.whiteColor,
                      //       activeTrackColor: AppColor.blueBorderColor,
                      //       inactiveTrackColor: AppColor.primaryColor.shade100,
                      //       inactiveThumbColor: AppColor.whiteColor,
                      //       // Removing the focus/outline
                      //       focusColor: Colors.transparent,
                      //       trackOutlineColor:
                      //           MaterialStateProperty.all(Colors.transparent),
                      //       onChanged: (value) {
                      //         setState(() {
                      //           useBiometric = value;
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // ),
                      onTap: () {
                        setState(() {
                          // useBiometric = !useBiometric;
                        });
                      }, // Implement navigation here
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
