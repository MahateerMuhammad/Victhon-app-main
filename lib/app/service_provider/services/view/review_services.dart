import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/services/controller/services_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/services/widget/add_service_dialog.dart';
import 'package:Victhon/app/service_provider/dashboard/widget/location_information_container.dart';
import 'package:Victhon/app/service_provider/dashboard/widget/pricing_information_container.dart';
import 'package:Victhon/app/service_provider/services/widget/service_images_container.dart';
import 'package:Victhon/app/service_provider/services/widget/service_information_container.dart';
import 'package:Victhon/utils/constants.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/loader.dart';

class ReviewServices extends StatefulWidget {
  const ReviewServices({super.key});

  @override
  State<ReviewServices> createState() => _ReviewServicesState();
}

class _ReviewServicesState extends State<ReviewServices> {
  final servicesController = Get.put(ServicesController());
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              leading: InkWell(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back),
              ),
              centerTitle: true,
              title: const TextWidget(
                text: "Review Service",
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
                      height: 24,
                    ),
                    const TextWidget(
                      text: "Review Your Service",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const TextWidget(
                      text:
                          "Verify the details below before adding your service.",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextWidget(
                      text: "Service Information",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // const Spacer(),
                    const SizedBox(
                      height: 12,
                    ),
                    ServiceInformationContainer(
                      serviceName:
                          servicesController.serviceNameController.value.text,
                      category: servicesController.serviceCategory.value,
                      description: servicesController
                          .serviceDescriptionController.value.text,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextWidget(
                      text: "Pricing Information",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // const Spacer(),
                    const SizedBox(
                      height: 12,
                    ),
                    PricingInformationContainer(
                      servicePrice: formatAsMoney(double.parse(
                          servicesController.servicePriceAmount.value
                              .toString())),
                      flexiblePricing:
                          servicesController.isFlexiblePricing.value
                              ? "ON"
                              : "OFF",
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextWidget(
                      text: "Location Information",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // const Spacer(),
                    const SizedBox(
                      height: 12,
                    ),
                    LocationInformationContainer(
                      remoteService:
                          servicesController.remoteService.value ? "ON" : "OFF",
                      onsiteService:
                          servicesController.onsiteService.value ? "ON" : "OFF",
                      inStoreService: servicesController.inStoreService.value
                          ? "ON"
                          : "OFF",
                      inStoreAddress: servicesController.inStoreService.value
                          ? "$street, $city, $state $country"
                          : "",
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const TextWidget(
                      text: "Service Images",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // const Spacer(),
                    const SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      spacing: 8, // Space between items horizontally
                      runSpacing: 8, // Space between items vertically
                      children: List.generate(
                        servicesController.serviceImages.length,
                        (index) => ServiceImagesContainer(
                          selectedImage:
                              servicesController.serviceImages[index]!,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppOutlinedButton(
                          buttonText: "Cancel",
                          onPressed: () {
                            showCancelDialog(context);
                          },
                          buttonWidth:
                              MediaQuery.of(context).size.width / 2 - 24,
                          textColor: AppColor.primaryColor,
                          borderColor: AppColor.primaryColor,
                        ),
                        AppPrimaryButton(
                          buttonText: "Add Service",
                          onPressed: () {
                            servicesController.createServices(
                              images: servicesController.serviceImages,
                              serviceName: servicesController
                                  .serviceNameController.value.text,
                              serviceCategory:
                                  servicesController.serviceCategoryId.value,
                              serviceDescription: servicesController
                                  .serviceDescriptionController.value.text,
                              servicePrice:
                                  servicesController.servicePriceAmount.value,
                              hourlyRate:
                                  servicesController.hourlyRateAmount.value,
                              isFlexiblePricing:
                                  servicesController.isFlexiblePricing.value,
                              isCustomPackage:
                                  servicesController.isCustomPackage.value,
                              serviceLocation:
                                  servicesController.serviceLocation,
                              serviceAddress:
                                  servicesController.inStoreService.value
                                      ? {
                                          "street": street.value,
                                          "city": city.value,
                                          "state": street.value,
                                          "country": country.value
                                        }
                                      : servicesController.serviceAddress,
                              context: context,
                            );
                          },
                          buttonWidth:
                              MediaQuery.of(context).size.width / 2 - 24,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          servicesController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
