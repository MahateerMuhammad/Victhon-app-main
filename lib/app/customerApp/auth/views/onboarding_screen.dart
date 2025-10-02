// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/views/signup_signin_as.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/utils/images.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../widget/app_outline_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> images = [
    AppImages.onboardingImages1,
    AppImages.onboardingImages2,
    AppImages.onboardingImages3,
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startImageTransition();
  }

  void _startImageTransition() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % images.length;
      });
      _startImageTransition(); // Continue the loop
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Animated Image Transition
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Image.asset(
                images[_currentIndex],
                key: ValueKey<int>(_currentIndex), // Key differentiates images
                width: double.infinity,
                height: screenHeight * 0.4,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(
              height: 20,
            ), // Push content to the bottom

            // Action points (dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? AppColor.primaryColor
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const TextWidget(
              text: "Get The Best Services",
              fontSize: 26,
              fontWeight: FontWeight.w500,
            ),
            const TextWidget(text: "Hire verified service providers"),
            const TextWidget(text: "Promote your service"),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppPrimaryButton(
                buttonText: "Sign Up",
                onPressed: () {
                  Get.to(() => const SignupSigninAs(
                        screenType: "Sign Up",
                      ));
                },
              ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppOutlinedButton(
                buttonText: "Sign up with Google",
                onPressed: () {
                  Get.to(() => const SignupSigninAs(
                        screenType: "Google Sign Up",
                      ));
                },
                imageString: AppIcons.googleGIcon,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextWidget(text: "Already have an account?"),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const SignupSigninAs(
                          screenType: "Log In",
                        ));
                  },
                  child: const TextWidget(
                    text: "Log in",
                    color: AppColor.blueColor,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
