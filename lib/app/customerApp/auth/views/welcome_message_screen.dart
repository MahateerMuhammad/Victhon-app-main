import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/widgets/loader_widget.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../controller/auth_controller.dart';

class WelcomeMessageScreen extends StatefulWidget {
  const WelcomeMessageScreen({
    super.key,
    required this.userType,
    required this.userName,
  });
  final String userType;
  final String userName;

  @override
  State<WelcomeMessageScreen> createState() => _WelcomeMessageScreenState();
}

class _WelcomeMessageScreenState extends State<WelcomeMessageScreen> {
  final authController = Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.startTimer(widget.userType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Image.asset(
              AppIcons.victhonLogo,
              scale: 8,
            ),
            const SizedBox(
              height: 32,
            ),
            TextWidget(
              text: "Welcome onboard, ${widget.userName}!",
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 24,
            ),
            widget.userType == "customer"
                ? const TextWidget(
                    text: "Your service provider is just a tap away!",
                    textAlign: TextAlign.center,
                  )
                : const TextWidget(
                    text: "Your customer is just a tap away!",
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(
              height: 24,
            ),
            const TextWidget(
              text: "Let's get started!",
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 32,
            ),
            const LoaderWidget()
          ],
        ),
      ),
    );
  }
}
