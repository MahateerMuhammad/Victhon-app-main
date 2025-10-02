import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/icons.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.signupOption,
    required this.emailOrPhonenumber,
    required this.userType,
    required this.otpVerificationType,
  });
  final String signupOption;
  final String emailOrPhonenumber;
  final String userType;
  final String otpVerificationType;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final authController = Get.put(AuthController());
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    TextWidget(
                      text: "Let's verify your ${widget.signupOption}",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      text:
                          "We have sent a 6 digit otp code to ${widget.emailOrPhonenumber}, please enter it below",
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: Pinput(
                        controller: authController.pinController,
                        defaultPinTheme: PinTheme(
                          width: 64,
                          height: 68,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.grayColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        length: 6,
                        // onCompleted: (value) {
                        //   authController.verifyOtp(
                        //     authController.emailPhoneNumberController.text,
                        //     value,
                        //     widget.userType,
                        //   );
                        // },
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Obx(() {
                      return authController.hasOtpExpired.value == false
                          ? Row(
                              children: [
                                const TextWidget(text: "Code will expire in "),
                                const SizedBox(
                                  width: 5,
                                ),
                                TextWidget(
                                  text:
                                      '00:${authController.remainingTime.value.toString().padLeft(2, '0')}',
                                  color: AppColor.primaryColor,
                                  fontSize: 13,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                const TextWidget(text: "Didn't get code?"),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    authController.signUp(
                                      authController.identifierController.text,
                                      authController.passwordController.text,
                                      widget.userType,
                                    );
                                    Future.delayed(const Duration(seconds: 5),
                                        () {
                                      authController.startCountdown();
                                    });
                                  },
                                  child: const TextWidget(
                                    text: 'Resend Code',
                                    color: AppColor.primaryColor,
                                  ),
                                )
                              ],
                            );
                    }),
                    const SizedBox(
                      height: 80,
                    ),
                    Obx(
                      () => AppPrimaryButton(
                        buttonText: "Verify",
                        buttonColor: authController.isFormFilled.value
                            ? AppColor.primaryColor
                            : AppColor.primaryColor.shade200,
                        onPressed: authController.isFormFilled.value
                            ? () {
                                if (formkey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  if (widget.otpVerificationType == "signUp") {
                                    authController.validateUserSignUp(
                                      authController.identifierController.text,
                                      authController.pinController.text,
                                      widget.userType,
                                    );
                                  } else {
                                    authController.verifyOtp(
                                      authController.identifierController.text,
                                      authController.pinController.text,
                                      widget.userType,
                                    );
                                  }
                                }
                              }
                            : () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        authController.isLoading.value
            ? const LoaderCircle()
            : const SizedBox(),
      ],
    );
  }
}
