import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/services/view/review_services.dart';
import 'package:Victhon/app/service_provider/services/widget/images_container.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../controller/services_controller.dart';

class AddServiceStage4 extends StatelessWidget {
  AddServiceStage4({super.key});
  final servicesController = Get.put(ServicesController());

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
      body: SingleChildScrollView(
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
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Upload Images",
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
              Row(
                children: [
                  ImagesContainer(
                    height: 220,
                    width: MediaQuery.of(context).size.width / 1.7,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        ImagesContainer(
                          height: 106,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ImagesContainer(
                          height: 106,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImagesContainer(
                    height: 106,
                    width: MediaQuery.of(context).size.width / 3.5,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ImagesContainer(
                    height: 106,
                    width: MediaQuery.of(context).size.width / 3.5,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ImagesContainer(
                    height: 106,
                    width: MediaQuery.of(context).size.width / 3.5,
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Image Upload Guidelines",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.backgroundYellow),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            text: "Supported formats: ",
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          TextWidget(
                            text: "JPEG, PNG, GIF",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: "Max file size: ",
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          TextWidget(
                            text: "5MB per image.",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextWidget(
                        text: "800x600px (for best display).",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        buttonText: "Back",
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
                        buttonText: "Review",
                        buttonColor: servicesController.serviceImages.length > 3
                            ? AppColor.primaryColor
                            : AppColor.primaryColor.shade200,
                        onPressed: servicesController.serviceImages.length > 3
                            ? () {
                                Get.to(() => ReviewServices());
                              }
                            : () {},
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
