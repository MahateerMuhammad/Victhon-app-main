import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/profile/view/confirm_transaction_pin.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';
import '../controller/service_provider_profile_controller.dart';

class CreateTransactionPin extends StatefulWidget {
  const CreateTransactionPin({super.key});

  @override
  State<CreateTransactionPin> createState() => _CreateTransactionPinState();
}

class _CreateTransactionPinState extends State<CreateTransactionPin> {
  final providerProfileController = Get.put(ServiceProviderProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const TextWidget(
          text: 'Create Transaction Pin',
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
                text: 'Create Transaction Pin',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 8,
              ),
              const TextWidget(
                text: 'This pin will be used for your transactions.',
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
                  controller: providerProfileController.pinController,
                  cursorHeight: 24,
                  // showCursor: false,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.primaryColor.shade50,
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, -24),
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
                buttonText: "Next",
                buttonColor: providerProfileController.pinController.length < 4
                    ? AppColor.primaryColor.shade200
                    : AppColor.primaryColor,
                onPressed: providerProfileController.pinController.length < 4
                    ? () {}
                    : () {
                        Get.to(() => const ConfirmTransactionPin());
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
