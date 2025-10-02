import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/bottomNavBar/view/service_provider_bottom_nav_bar.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';

import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../../../widget/textwidget.dart';

void showSuccessfulDialog(BuildContext context) {
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
              text: "Service Added Successfully",
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor,
              fontSize: 16,
            ),
            const SizedBox(
              height: 8,
            ),
            const TextWidget(
              text:
                  "Your service has been successfully added and is now visible to potential clients.",
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppOutlinedButton(
                  buttonText: "Create Another",
                  onPressed: () {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();

                    // Get.to(() => const SetAvailability(
                    //       availabilityHeader: "Set Availability",
                    //     ));
                  },
                  buttonWidth: MediaQuery.of(context).size.width / 2 - 40,
                  textColor: AppColor.primaryColor,
                  borderColor: AppColor.primaryColor,
                ),
                const SizedBox(
                  width: 16,
                ),
                AppPrimaryButton(
                  buttonText: "Done",
                  onPressed: () {
                    Get.clearRouteTree();
                    Get.to(() => const ServiceProviderBottomNavBar());
                  },
                  buttonWidth: MediaQuery.of(context).size.width / 2 - 40,
                )
              ],
            )
          ],
        ),
      );
    },
  );
}

void showCancelDialog(BuildContext context) {
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
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent full-screen expansion
          children: [
            Image.asset(
              AppIcons.cancelMarkBadge,
              scale: 4,
            ),
            const SizedBox(
              height: 24,
            ),
            const TextWidget(
              text: "Are You sure You Want To Cancel?",
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor,
              fontSize: 16,
            ),
            const SizedBox(
              height: 8,
            ),
            const TextWidget(
              text:
                  "If you cancel now, all the information you’ve entered will be lost. Do you still want to proceed?",
              fontWeight: FontWeight.w400,
              color: AppColor.blackColor,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppOutlinedButton(
                  buttonText: "No, Go Back",
                  onPressed: () {
                    Get.back();
                  },
                  buttonWidth: MediaQuery.of(context).size.width / 2 - 40,
                  textColor: AppColor.primaryColor,
                  borderColor: AppColor.primaryColor,
                ),
                const SizedBox(
                  width: 16,
                ),
                AppPrimaryButton(
                  buttonText: "Yes, Cancel",
                  onPressed: () {
                    Get.clearRouteTree();
                    Get.to(() => const ServiceProviderBottomNavBar());
                  },
                  buttonWidth: MediaQuery.of(context).size.width / 2 - 40,
                )
              ],
            )
          ],
        ),
      );
    },
  );
}
