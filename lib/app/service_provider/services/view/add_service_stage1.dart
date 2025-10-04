import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/services/controller/services_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/services/view/add_service_stage2.dart';
import 'package:Victhon/app/service_provider/services/widget/categories_dropdown.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/app_textfield.dart';
import 'package:Victhon/widget/textwidget.dart';

class AddServiceStage1 extends StatefulWidget {
  const AddServiceStage1({super.key});

  @override
  State<AddServiceStage1> createState() => _AddServiceStage1State();
}

class _AddServiceStage1State extends State<AddServiceStage1> {
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
          text: "Add Service",
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
      ),
      body: Obx(
        () => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                  child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 4,
                          ),
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? AppColor.primaryColor
                                : AppColor.primaryColor.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 24,
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
                CategoriesDropdown(),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
                        fontWeight: FontWeight.w300,
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
                        buttonText: "Cancel",
                        onPressed: () {},
                        textColor: AppColor.primaryColor,
                        borderColor: AppColor.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: AppPrimaryButton(
                        buttonText: "Next",
                        buttonColor: servicesController.isFormFilled.value
                            ? AppColor.primaryColor
                            : AppColor.primaryColor.shade200,
                        onPressed: servicesController.isFormFilled.value
                            ? () {
                                servicesController.isFormFilled.value = false;
                                Get.to(() => const AddServiceStage2());
                              }
                            : () {},
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
