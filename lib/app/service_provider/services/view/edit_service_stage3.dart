import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/services/widget/address_dialog.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../controller/services_controller.dart';
import 'review_services.dart';

class EditServiceStage3 extends StatefulWidget {
  const EditServiceStage3({
    super.key,
    required this.editType,
    required this.country,
    required this.state,
    required this.city,
    required this.street,
  });
  final String editType;
  final String country;
  final String state;
  final String city;
  final String street;

  @override
  State<EditServiceStage3> createState() => _EditServiceStage3State();
}

class _EditServiceStage3State extends State<EditServiceStage3> {
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
          text: "Edit Service",
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
            const SizedBox(
              height: 8,
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
                              servicesController.serviceLocation.add("Remote");
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
                              servicesController.serviceLocation.add("OnSite");
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextWidget(
                          text:
                              "${widget.street}, ${widget.city}, ${widget.state}, ${widget.country}",
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
                        Get.back();
                        Get.to(() => ReviewServices());
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
    );
  }
}
