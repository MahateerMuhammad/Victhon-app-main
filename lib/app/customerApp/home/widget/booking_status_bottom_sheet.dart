import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/bottonNavBar/view/bottom_nav_bar.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/textwidget.dart';

void showBookingStatusDialog(
  BuildContext context,
) {
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
              AppIcons.checkMarkBadge,
              scale: 4,
            ),
            const SizedBox(
              height: 24,
            ),
            const TextWidget(
              text: "Booking Successful",
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor,
              fontSize: 16,
            ),
            const SizedBox(
              height: 8,
            ),
            const TextWidget(
              text:
                  "Your booking request has been sent to the service provider.",
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    buttonText: "Go Back",
                    borderColor: AppColor.primaryColor,
                    textColor: AppColor.primaryColor,
                    onPressed: () {
                      Get.back();
                      Get.back();
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: AppPrimaryButton(
                    buttonText: "View Request",
                    onPressed: () {
                      Get.back();
                      Get.back();

                      Get.off(() => const CustomerBottomNavBar(
                                index: 1,
                              ));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
