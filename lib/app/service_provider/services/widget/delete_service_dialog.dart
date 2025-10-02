import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../../../widget/textwidget.dart';
import '../controller/services_controller.dart';

class DeleteServiceDialog extends StatelessWidget {
  DeleteServiceDialog({
    super.key,
    required this.serviceId,
  });
  final String serviceId;

  final serviceController = Get.put(ServicesController());

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
            text: "Delete Service",
            fontWeight: FontWeight.w600,
            color: AppColor.blackColor,
            fontSize: 20,
          ),
          const SizedBox(
            height: 4,
          ),
          const TextWidget(
            text: "Are you sure you want to delete this service?",
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
                    await serviceController.deleteService(serviceId);
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

void showDeleteServiceDialog(
  String serviceId,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DeleteServiceDialog(
        serviceId: serviceId,
      );
    },
  );
}
