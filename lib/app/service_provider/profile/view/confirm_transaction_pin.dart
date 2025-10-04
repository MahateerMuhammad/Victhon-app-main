import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Victhon/widget/app_botton.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../controller/service_provider_profile_controller.dart';

class ConfirmTransactionPin extends StatefulWidget {
  const ConfirmTransactionPin({super.key});

  @override
  State<ConfirmTransactionPin> createState() => _ConfirmTransactionPinState();
}

class _ConfirmTransactionPinState extends State<ConfirmTransactionPin> {
  final providerProfileController = Get.put(ServiceProviderProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              title: const TextWidget(
                text: 'Confirm Transaction Pin',
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
                    const TextWidget(
                      text: 'Confirm Transaction Pin',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const TextWidget(
                      text:
                          'This pin should be the same with the one you just entered previously',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 46,
                      width: 120,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        controller:
                            providerProfileController.confirmPinController,
                        cursorHeight: 24,
                        // showCursor: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                        ],
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.primaryColor.shade50,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 16, -24),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    AppPrimaryButton(
                      buttonText: "Create Transaction PIN",
                      buttonColor: providerProfileController
                                  .confirmPinController.text.length <
                              4
                          ? AppColor.primaryColor.shade200
                          : AppColor.primaryColor,
                      onPressed: providerProfileController
                                  .confirmPinController.text.length <
                              4
                          ? () {}
                          : () {
                              if (providerProfileController
                                      .pinController.text ==
                                  providerProfileController
                                      .confirmPinController.text) {
                                providerProfileController.setTransactionPin(
                                    providerProfileController
                                        .confirmPinController.text,
                                    context);
                              } else {
                                Get.snackbar(
                                    "Alert", "Incorrect Confirmation Pin");
                              }
                            },
                    )
                  ],
                ),
              ),
            ),
          ),
          providerProfileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
