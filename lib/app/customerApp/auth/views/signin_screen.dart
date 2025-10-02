import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/views/forgot_password_screen.dart';
import 'package:Victhon/app/customerApp/auth/views/signup_signin_as.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/server/google_sign_in.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/icons.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../../../widget/custom_form_field.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../controller/auth_controller.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({
    super.key,
    required this.userType,
  });
  final String userType;

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final authController = Get.put(AuthController());
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    authController.emailController.dispose();
    authController.passwordController.dispose();
  }

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
                        height: 40,
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
                        text: "Welcome Back",
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
                        validator: (value) => identifyInput(value ?? ''),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const TextWidget(
                        text: "Password",
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
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => ForgotPasswordScreen(
                                userType: widget.userType,
                              ));
                        },
                        child: const TextWidget(
                          text: "Forgot your password?",
                          color: AppColor.blueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Obx(
                        () => AppPrimaryButton(
                          buttonText: "Log In",
                          buttonColor: authController.isFormFilled.value
                              ? AppColor.primaryColor
                              : AppColor.primaryColor.shade200,
                          onPressed: authController.isFormFilled.value
                              ? () {
                                  if (formkey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    authController.signIn(
                                      authController.identifierController.text,
                                      authController.passwordController.text,
                                      widget.userType,
                                    );
                                  } else {
                                    debugPrint("Login is failed");
                                  }
                                }
                              : () {},
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColor.grayColor,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const TextWidget(text: "OR"),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColor.grayColor,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AppOutlinedButton(
                        buttonText: "Sign in with Google",
                        onPressed: () async {
                          await signInWithGoogle(widget.userType, "signIn");
                        },
                        imageString: AppIcons.googleGIcon,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextWidget(text: "Don't have an account?"),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                              Get.off(() => const SignupSigninAs(
                                    screenType: "Sign Up",
                                  ));
                            },
                            child: const TextWidget(
                              text: "Sign up",
                              color: AppColor.blueColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
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
