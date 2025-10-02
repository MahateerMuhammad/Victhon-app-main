import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/profile/view/create_transaction_pin.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/textwidget.dart';

void showWithdrawDialog(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
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
              AppIcons.walletBlueIcon,
              scale: 4,
            ),
            const SizedBox(
              height: 24,
            ),
            const TextWidget(
              text: "Create Transaction Pin",
              fontWeight: FontWeight.w500,
              color: AppColor.blackColor,
              fontSize: 16,
            ),
            const SizedBox(
              height: 8,
            ),
            const TextWidget(
              text:
                  "Set up a 4-digit PIN to secure your withdrawals. You'll need this PIN every time you make a withdrawal",
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
                    borderColor: AppColor.primaryColor,
                    textColor: AppColor.primaryColor,
                    buttonText: "Cancel",
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
                    buttonText: "Create PIN",
                    onPressed: () {
                      Get.back();
                      Get.to(() => CreateTransactionPin());
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
