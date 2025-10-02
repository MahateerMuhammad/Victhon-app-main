import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../../../widget/textwidget.dart';
import '../controller/service_provider_profile_controller.dart';

class ProviderLogoutDialog extends StatelessWidget {
  ProviderLogoutDialog({
    super.key,
  });

  final providerProfileController = Get.put(ServiceProviderProfileController());

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
          const Icon(
            Icons.error,
            size: 40,
            color: AppColor.redColor1,
          ),
          const SizedBox(
            height: 16,
          ),
          const TextWidget(
            text: "Log Out",
            fontWeight: FontWeight.w600,
            color: AppColor.blackColor,
            fontSize: 20,
          ),
          const SizedBox(
            height: 4,
          ),
          const TextWidget(
            text: "Are you sure you want to log out?            ",
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
                  buttonText: "No",
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
                  buttonText: "Yes",
                  onPressed: () async {
                    Get.back();
                    await providerProfileController.signOut();
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

void showProviderLogoutDialog(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ProviderLogoutDialog();
    },
  );
}
