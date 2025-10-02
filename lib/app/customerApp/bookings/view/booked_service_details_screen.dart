import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../controller/bookings_controller.dart';
import '../widget/booked_services_details_component.dart';

class BookedServiceDetailsScreen extends StatelessWidget {
  BookedServiceDetailsScreen({
    super.key,
    required this.service,
  });
  final Map service;

  final bookingsController = Get.put(CustomerBookingsController());

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
              centerTitle: true,
              leading: GestureDetector(
                child: const Icon(Icons.arrow_back, color: Colors.black),
                onTap: () {
                  Get.back();
                  // Handle back navigation
                },
              ),
              title: const TextWidget(
                text: "Service Details",
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            body: SingleChildScrollView(
              child: BookedServicesDetailsComponent(
                service: service,
              ),
            ),
          ),
          bookingsController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox(),
        ],
      ),
    );
  }
}
