import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/controller/auth_controller.dart';
import 'package:Victhon/app/customerApp/auth/widgets/password_container.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/custom_form_field.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../utils/functions.dart';
import '../../../../widget/loader.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
    required this.userType,
  });
  final String userType;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final authController = Get.find<AuthController>();
  final formkey = GlobalKey<FormState>();

  bool containsUppercase = false;

  // @override
  // void dispose() {
  //   authController.emailPhoneNumberController.dispose();
  //   authController.passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Obx(
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
                          text: "Sign Up to Victhon",
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
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
                          validator: (value) => identifyInput(value ??''),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const TextWidget(
                          text: "Create Password",
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomFormField(
                          controller: authController.passwordController,
                          hintText: "Enter your password",
                          obsecure: authController.passwordObscure.value,
                          isSuffixIcon: true,
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(
                              authController.passwordObscure.value
                                  ? Icons.visibility_off
                                  : Icons
                                      .visibility, //change icon based on boolean value
                              color: authController.passwordObscure.value
                                  ? AppColor.primaryColor.shade100
                                  : AppColor.primaryColor,
                            ),
                            onPressed: () {
                              authController.passwordObscureFunction();
                            },
                          ),
                          onChanged: (value) {
                            authController.validatePassword(value);
                          },
                          validator: (value) => authController
                              .validatePasswordStrength(value ?? ''),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 16,
                          children: [
                            Obx(() => PasswordContainer(
                                  containerText: "6 Character",
                                  isActive: authController.hasMinLength.value,
                                )),
                            Obx(() => PasswordContainer(
                                  containerText: "Uppercase",
                                  isActive: authController.hasUppercase.value,
                                )),
                            Obx(() => PasswordContainer(
                                  containerText: "Lowercase",
                                  isActive: authController.hasLowercase.value,
                                )),
                            Obx(() => PasswordContainer(
                                  containerText: "Number",
                                  isActive: authController.hasNumber.value,
                                )),
                            Obx(() => PasswordContainer(
                                  containerText: "Special Character",
                                  isActive: authController.hasSpecialChar.value,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        Obx(
                          () => AppPrimaryButton(
                            buttonText: "Sign Up",
                            buttonColor: authController.isFormFilled.value
                                ? AppColor.primaryColor
                                : AppColor.primaryColor.shade200,
                            onPressed: authController.isFormFilled.value
                                ? () {
                                    if (formkey.currentState!.validate()) {
                                      FocusScope.of(context).unfocus();
                                      authController.signUp(
                                        authController
                                            .identifierController.text,
                                        authController.passwordController.text,
                                        widget.userType,
                                      );
                                    } else {
                                      debugPrint("SignUp is failed");
                                    }
                                  }
                                : () {},
                          ),
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
      ),
    );
  }
}
