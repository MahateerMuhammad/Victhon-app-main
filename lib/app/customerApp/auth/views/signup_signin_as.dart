import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/controller/auth_controller.dart';
import 'package:Victhon/app/customerApp/auth/views/signup_screen.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../data/server/google_sign_in.dart';
import '../../../../widget/loader.dart';
import 'signin_screen.dart';

class SignupSigninAs extends StatefulWidget {
  const SignupSigninAs({
    super.key,
    required this.screenType,
  });
  final String screenType;

  @override
  State<SignupSigninAs> createState() => _SignupSigninAsState();
}

class _SignupSigninAsState extends State<SignupSigninAs> {
  final authController = Get.put(AuthController());

  String userType = "customer";

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      text: "${widget.screenType} As",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              userType = "customer";
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: userType == "customer"
                                    ? AppColor.primaryColor
                                    : AppColor.inactiveColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextWidget(
                                text: "Customer",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: userType == "customer"
                                    ? AppColor.primaryColor
                                    : AppColor.blackColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              userType = "provider";
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: userType == "provider"
                                    ? AppColor.primaryColor
                                    : AppColor.inactiveColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextWidget(
                                text: "Service Provider",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                textAlign: TextAlign.center,
                                color: userType == "provider"
                                    ? AppColor.primaryColor
                                    : AppColor.blackColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    widget.screenType == "Google Sign Up"
                        ? AppPrimaryButton(
                            buttonText: authController.isLoading.value
                                ? "Loading..."
                                : "Sign up",
                            onPressed: authController.isLoading.value
                                ? () {}
                                : () async {
                                    authController.isLoading.value = true;

                                    await signInWithGoogle(userType, "signUp");
                                  },
                          )
                        : AppPrimaryButton(
                            buttonText: "Next",
                            onPressed: () async {
                              if (widget.screenType == "Log In") {
                                Get.to(() => SigninScreen(
                                      userType: userType,
                                    ));
                              } else if (widget.screenType == "Sign Up") {
                                Get.to(() => SignupScreen(
                                      userType: userType,
                                    ));
                              }
                            },
                          )
                  ],
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
