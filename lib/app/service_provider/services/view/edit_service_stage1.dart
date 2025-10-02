import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/services/widget/categories_dropdown.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/app_textfield.dart';
import '../controller/services_controller.dart';
import 'review_services.dart';

class EditServiceStage1 extends StatefulWidget {
  const EditServiceStage1({super.key, required this.editType});
  final String editType;

  @override
  State<EditServiceStage1> createState() => _EditServiceStage1State();
}

class _EditServiceStage1State extends State<EditServiceStage1> {
  final servicesController = Get.put(ServicesController());

  int _currentLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const TextWidget(
          text: "Edit Service",
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              const TextWidget(
                text: "Service Details",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 4,
              ),
              const TextWidget(
                text: "Expand your offerings and reach more clients.",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Service Name",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 8,
              ),
              AppTextfield(
                controller: servicesController.serviceNameController,
                hintText: "What Service do you provide",
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Category",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 8,
              ),
              CategoriesDropdown(
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Description",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 150,
                child: TextField(
                  controller: servicesController.serviceDescriptionController,

                  cursorHeight: 18,
                  maxLines: 5,
                  maxLength: 300, // Maximum character limit
                  onChanged: (text) {
                    setState(() {
                      _currentLength = text.length; // Updates character count
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.primaryCardColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Provide a deep description of your service",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                    counterText:
                        '$_currentLength/300', // Display character count
                    counterStyle: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      buttonText: widget.editType == "Manage Services"
                          ? "Back"
                          : "Discard Changes",
                      onPressed: () {
                        Get.back();
                      },
                      textColor: AppColor.primaryColor,
                      borderColor: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: AppPrimaryButton(
                      buttonText: widget.editType == "Manage Services"
                          ? "Next"
                          : "Save Changes",
                      onPressed: () {
                        Get.back();
                        Get.to(() => ReviewServices());
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
