import 'package:flutter/material.dart';
import 'package:Victhon/widget/app_botton.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/custom_form_field.dart';
import '../../../../widget/textwidget.dart';

class ForgotTransactionPin extends StatelessWidget {
  const ForgotTransactionPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const TextWidget(
          text: 'Forgot Transaction PIN',
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
                text:
                    'Please enter the email address linked to your account, and we’ll send you a confirmation email to reset your Transaction PIN.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 32,
              ),
              const TextWidget(
                text: 'Email/Phone number',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomFormField(hintText: "Enter Email or Phone number"),
              const SizedBox(
                height: 40,
              ),
              AppPrimaryButton(
                buttonText: "Send Code",
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
