import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/services/view/manage_services.dart';
import 'package:Victhon/app/service_provider/services/widget/delete_service_dialog.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/loader.dart';
import '../controller/services_controller.dart';
import 'add_service_stage1.dart';

class ServicesList extends StatefulWidget {
  const ServicesList({
    super.key,
  });

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  final serviceController = Get.put(ServicesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColor.whiteColor,
              surfaceTintColor: AppColor.whiteColor,
              title: const TextWidget(
                text: "Services",
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Services Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: AppColor.primaryCardColor,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextWidget(
                                      text: "Services",
                                      fontSize: 14,
                                      color: Colors.black54),
                                  const SizedBox(height: 4),
                                  TextWidget(
                                    text:
                                        "${serviceController.providerServices.length}",
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.business_center,
                                color: AppColor.primaryColor,
                                size: 35,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          AppPrimaryButton(
                            buttonText: "Add New Service",
                            onPressed: () {
                              // Get.find<ServicesController>().fetchAllCategories();

                              Get.to(
                                () => const AddServiceStage1(),
                              )!
                                  .then((_) {
                                Get.find<ServicesController>()
                                    .fetchProviderServices();
                              });
                              ;
                            },
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Services List
                  Obx(() {
                    if (serviceController.isLoading.isTrue) {
                      return const SizedBox();
                    } else {
                      if (serviceController.providerServices.isEmpty) {
                        return const SizedBox(); // Show loader while fetching
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount:
                                serviceController.providerServices.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: "Service ${index + 1}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  TextWidget(
                                    text: serviceController
                                        .providerServices[index]["serviceName"],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AppOutlinedButton(
                                          buttonText: "Delete Service",
                                          textColor: AppColor.primaryColor,
                                          borderColor: AppColor.primaryColor,
                                          onPressed: () {
                                            showDeleteServiceDialog(
                                                serviceController
                                                        .providerServices[index]
                                                    ["_id"],
                                                context);
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: AppOutlinedButton(
                                          buttonText: "Service Details",
                                          textColor: AppColor.primaryColor,
                                          borderColor: AppColor.primaryColor,
                                          onPressed: () {
                                            Get.to(
                                              () => ManageServices(
                                                services: serviceController
                                                    .providerServices[index],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        );
                      }
                    }
                  }),
                ],
              ),
            ),
          ),
          serviceController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
