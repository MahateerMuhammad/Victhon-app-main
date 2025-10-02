import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/services/widget/manage_service_images_container.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/dashboard/widget/location_information_container.dart';
import 'package:Victhon/app/service_provider/dashboard/widget/pricing_information_container.dart';
import 'package:Victhon/app/service_provider/services/widget/service_information_container.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../controller/service_money_controller.dart';
import '../controller/services_controller.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({
    super.key,
    required this.services,
  });
  final Map services;

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  final servicesController = Get.put(ServicesController());
  final moneyController = Get.put(ServiceMoneyController());

  List imageList = [];
  List serviceLocation = [];

  @override
  void initState() {
    imageList = widget.services["imageUrls"];
    serviceLocation = serviceLocation;
    super.initState();
  }

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
          // text: "Manage Service",
          text: "Service Details",
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
                text: "Review Your Service",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 4,
              ),
              const TextWidget(
                text: "Verify the details below before adding your service.",
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
              const SizedBox(
                height: 12,
              ),
              ServiceInformationContainer(
                serviceName: widget.services["serviceName"],
                category: "",
                // widget.services["serviceCategory"]["categoryName"],
                description: widget.services["serviceDescription"],
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Pricing Information",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              const SizedBox(
                height: 12,
              ),
              PricingInformationContainer(
                servicePrice: formatAsMoney(
                    double.parse(widget.services["servicePrice"].toString())),
                // flexiblePricing: "ON",
                flexiblePricing:
                    widget.services["isFlexiblePricing"].toString(),
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Location Information",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              const SizedBox(
                height: 12,
              ),
              LocationInformationContainer(
                remoteService:
                    serviceLocation.contains("Remote") ? "ON" : "OFF",
                onsiteService:
                    serviceLocation.contains("OnSite") ? "ON" : "OFF",
                inStoreService:
                    serviceLocation.contains("In-Store") ? "ON" : "OFF",
                inStoreAddress: serviceLocation.contains("In-Store")
                    ? "${widget.services["serviceAddress"]["street"]}, ${widget.services["serviceAddress"]["city"]}, ${widget.services["serviceAddress"]["state"]}, ${widget.services["serviceAddress"]["country"]}"
                    : '',
              ),
              const SizedBox(
                height: 24,
              ),
              const TextWidget(
                text: "Service Images",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              const SizedBox(
                height: 12,
              ),
              Wrap(
                spacing: 8, // Space between items horizontally
                runSpacing: 8, // Space between items vertically
                children: List.generate(
                  imageList.length,
                  (index) => ManageServiceImagesContainer(
                    selectedImage: imageList[index],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
