import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/home/controller/home_controllers.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/icons.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../../../widget/textwidget.dart';

class RequestDialog extends StatelessWidget {
  RequestDialog({
    super.key,
    required this.serviceId,
    required this.paymentMethod,
    required this.message,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
  });
  final String serviceId;
  final String paymentMethod;
  final String message;
  final String street;
  final String city;
  final String state;
  final String country;
  final homeController = Get.put(HomeControllers());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      backgroundColor: AppColor.whiteColor,
      content: Column(
        mainAxisSize: MainAxisSize.min, // Prevent full-screen expansion
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppIcons.serviceProviderIcon,
            color: AppColor.primaryColor,
            scale: 4,
          ),
          const SizedBox(
            height: 16,
          ),
          const TextWidget(
            text: "Confirm Request",
            fontWeight: FontWeight.w600,
            color: AppColor.blackColor,
            fontSize: 20,
          ),
          const SizedBox(
            height: 4,
          ),
          const TextWidget(
            text: "Confirm request details to make a request.",
            fontWeight: FontWeight.w400,
            color: AppColor.blackColor,
            fontSize: 16,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  buttonText: "Cancel",
                  borderColor: AppColor.primaryColor,
                  textColor: AppColor.primaryColor,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: AppPrimaryButton(
                  buttonText: "Confirm",
                  onPressed: () async {
                    Get.back();
                    await homeController.bookService(
                      serviceId,
                      paymentMethod,
                      message,
                      street,
                      city,
                      state,
                      country,
                      context,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showRequestDialog(
  String serviceId,
  String paymentMethod,
  String message,
  String street,
  String city,
  String state,
  String country,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return RequestDialog(
        serviceId: serviceId,
        paymentMethod: paymentMethod,
        message: message,
        street: street,
        city: city,
        state: state,
        country: country,
      );
    },
  );
}
