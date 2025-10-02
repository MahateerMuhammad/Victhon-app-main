import 'package:flutter/material.dart';
import 'package:Victhon/widget/app_botton.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class ChangeTransactionPin extends StatelessWidget {
  const ChangeTransactionPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const TextWidget(
          text: 'Change Transaction Pin',
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
                text: 'Verify Transaction Pin',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 8,
              ),
              const TextWidget(
                text: 'Please enter your current pin to verify your identity before proceeding to change it.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 46,
                width: 120,
                child: TextField(
                  keyboardType: TextInputType.number,
                  obscureText: true,

                  cursorHeight: 24,
                  // showCursor: false,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
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
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              AppPrimaryButton(
                buttonText: "Send Code",
                onPressed: () {
                  // Get.to(() => const ConfirmTransactionPin());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
