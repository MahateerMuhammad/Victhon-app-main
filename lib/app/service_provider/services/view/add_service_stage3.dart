import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/services/widget/address_dialog.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../utils/constants.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../controller/services_controller.dart';
import 'add_service_stage4.dart';

class AddServiceStage3 extends StatefulWidget {
  const AddServiceStage3({super.key});

  @override
  State<AddServiceStage3> createState() => _AddServiceStage3State();
}

class _AddServiceStage3State extends State<AddServiceStage3> {
  final servicesController = Get.put(ServicesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
        body: Padding(
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
                          color: index == 3
                              ? AppColor.primaryColor.shade50
                              : AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Choose Service Location",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 4,
              ),
              const TextWidget(
                text: "Decide where your services will be provided.",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Service Location",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const TextWidget(
                    text: "Remote ",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const TextWidget(
                    text: "(Online Services)",
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    width: 45,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                          value: servicesController.remoteService.value,
                          activeColor: AppColor.whiteColor,
                          activeTrackColor: AppColor.blueBorderColor,
                          inactiveTrackColor: AppColor.primaryColor.shade100,
                          inactiveThumbColor: AppColor.whiteColor,
                          // Removing the focus/outline
                          focusColor: Colors.transparent,
                          trackOutlineColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onChanged: (value) {
                            setState(() {
                              servicesController.remoteService.value = value;
                              if (value) {
                                servicesController.serviceLocation
                                    .add("Remote");
                              } else if (!value) {
                                servicesController.serviceLocation
                                    .remove("Remote");
                              }
                            });
                          }),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const TextWidget(
                    text: "Onsite ",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const TextWidget(
                    text: "(Customer Location)",
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    width: 45,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                          value: servicesController.onsiteService.value,
                          activeColor: AppColor.whiteColor,
                          activeTrackColor: AppColor.blueBorderColor,
                          inactiveTrackColor: AppColor.primaryColor.shade100,
                          inactiveThumbColor: AppColor.whiteColor,
                          // Removing the focus/outline
                          focusColor: Colors.transparent,
                          trackOutlineColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onChanged: (value) {
                            setState(() {
                              servicesController.onsiteService.value = value;
                              if (value) {
                                servicesController.serviceLocation
                                    .add("OnSite");
                              } else if (!value) {
                                servicesController.serviceLocation
                                    .remove("OnSite");
                              }
                            });
                          }),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const TextWidget(
                    text: "In-Store ",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const TextWidget(
                    text: "(Your Address)",
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    width: 45,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                          value: servicesController.inStoreService.value,
                          activeColor: AppColor.whiteColor,
                          activeTrackColor: AppColor.blueBorderColor,
                          inactiveTrackColor: AppColor.primaryColor.shade100,
                          inactiveThumbColor: AppColor.whiteColor,
                          // Removing the focus/outline
                          focusColor: Colors.transparent,
                          trackOutlineColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onChanged: (value) {
                            setState(() {
                              servicesController.inStoreService.value = value;
                              if (value) {
                                servicesController.serviceLocation
                                    .add("In-Store");
                              } else if (!value) {
                                servicesController.serviceLocation
                                    .remove("In-Store");
                              }
                              if (servicesController.inStoreService.value) {
                                showServiceProviderAddressDialog(context);
                              }
                            });
                          }),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () => showServiceProviderAddressDialog(context),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.backgroundYellow,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextWidget(
                            text: "$street, $city, $state, $country",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.location_pin,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
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
                      buttonText: "Next",
                      buttonColor: servicesController.remoteService.value ==
                                  false &&
                              servicesController.onsiteService.value == false &&
                              servicesController.inStoreService.value == false
                          ? AppColor.primaryColor.shade200
                          : AppColor.primaryColor,
                      onPressed: () {
                        print("77777777 ${servicesController.serviceLocation}");
                        if (servicesController.remoteService.value == false &&
                            servicesController.onsiteService.value == false &&
                            servicesController.inStoreService.value == false) {
                        } else {
                          Get.to(() => AddServiceStage4());
                        }
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
