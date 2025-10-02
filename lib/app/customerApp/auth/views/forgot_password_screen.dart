import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/controller/auth_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/custom_form_field.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/loader.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.userType,
  });
  final String userType;
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final authController = Get.put(AuthController());
  final formkey = GlobalKey<FormState>();

  // @override
  // void dispose() {
  //   authController.emailPhoneNumberController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.arrow_back),
                          ),
                          const Spacer(),
                          Image.asset(
                            AppIcons.victhonLogo,
                            scale: 10,
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const TextWidget(
                        text: "Forgot Password?",
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const TextWidget(
                          text:
                              "Please enter your email address or phone number used in signing up to reset your password"),
                      const SizedBox(
                        height: 20,
                      ),
                      const TextWidget(
                        text: "Email",
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormField(
                        controller: authController.identifierController,
                        hintText: "Enter your email",
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      AppPrimaryButton(
                        buttonText: "Send",
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            authController.forgotPassword(
                              authController.identifierController.text,
                              widget.userType,
                            );
                          } else {
                            debugPrint("Login is failed");
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          authController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
