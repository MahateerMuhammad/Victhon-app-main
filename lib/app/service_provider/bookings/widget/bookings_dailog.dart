import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/createProfile/views/add_bank_details.dart';
import 'package:Victhon/config/theme/app_color.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/textwidget.dart';

void showStatusDialog(BuildContext context, String statusImage,
    String headerText, String subText, String buttonText,
    {bool createProfile = false}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    backgroundColor: Colors.transparent, // Ensures rounded corners look good
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent full-screen expansion
          children: [
            Image.asset(
              statusImage,
              scale: 4,
            ),
            const SizedBox(
              height: 24,
            ),
            TextWidget(
              text: headerText,
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor,
              fontSize: 16,
            ),
            const SizedBox(
              height: 8,
            ),
            TextWidget(
              text: subText,
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            createProfile
                ? AppPrimaryButton(
                    buttonText: buttonText,
                    onPressed: () {
                      Get.to(() => const AddBankDetails());
                    },
                  )
                : AppPrimaryButton(
                    buttonText: buttonText,
                    onPressed: () {
                      Get.back();
                      Get.back();
                      Get.back();

                    },
                  )
          ],
        ),
      );
    },
  );
}
