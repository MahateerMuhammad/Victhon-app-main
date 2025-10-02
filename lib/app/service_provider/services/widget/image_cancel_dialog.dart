import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';

import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';

void showImageCancelDialog({
  required BuildContext context,
  required VoidCallback onDelete,
  required VoidCallback onReplace,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPrimaryButton(
              buttonText: "Delete Image",
              onPressed: () {
                Get.back();
                onDelete();
              },
              buttonColor: AppColor.primaryColor.shade50,
              textColor: AppColor.primaryColor,
            ),
            const SizedBox(height: 8),
            AppPrimaryButton(
              buttonText: "Replace Image",
              onPressed: () {
                Get.back();
                onReplace();
              },
              buttonColor: AppColor.primaryColor.shade50,
              textColor: AppColor.primaryColor,
            ),
            const SizedBox(height: 16),
            AppOutlinedButton(
              buttonText: "Cancel",
              onPressed: () {
                Get.back();
              },
              textColor: AppColor.primaryColor,
              borderColor: AppColor.primaryColor,
            ),
          ],
        ),
      );
    },
  );
}
