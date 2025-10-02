import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../config/theme/app_color.dart';

customSnackbar(tittle, message, color) {
  Get.snackbar(
    tittle,
    message,
    snackPosition: SnackPosition.TOP,
    forwardAnimationCurve: Curves.easeInOutCubic,
    reverseAnimationCurve: Curves.easeInOutCubic,
    backgroundColor: color,
    colorText: Colors.white,
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    icon: tittle != "ERROR".tr
        ? const Icon(
            Icons.check_circle,
            color: Colors.white,
          )
        : const Icon(
            Icons.error,
            color: Colors.white,
          ),
    duration: const Duration(milliseconds: 3000),
  );
}

customBottomSnackbar(message, color) {
  Get.snackbar(
    message,
    '',
    titleText: Center(
        child: TextWidget(
      text: message,
      fontSize: 16,
      color: AppColor.whiteColor,
      fontWeight: FontWeight.bold,
    )),
    snackPosition: SnackPosition.BOTTOM,
    forwardAnimationCurve: Curves.easeInOutCubic,
    reverseAnimationCurve: Curves.easeInOutCubic,
    backgroundColor: color,
    colorText: Colors.white,
    borderRadius: 0,
    padding: EdgeInsets.only(bottom: 0, top: 16),
    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    // icon: tittle != "ERROR".tr
    //     ? const Icon(
    //         Icons.check_circle,
    //         color: Colors.white,
    //       )
    //     : const Icon(
    //         Icons.error,
    //         color: Colors.white,
    //       ),
    duration: const Duration(milliseconds: 3000),
  );
}
