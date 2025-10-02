import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/bookings/controller/bookings_controller.dart';
import 'package:Victhon/app/customerApp/bookings/widget/bookings_shimmer_loader.dart';
import 'package:Victhon/app/customerApp/bookings/widget/empty_bookings_widget.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../config/theme/app_color.dart';
import 'booked_service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final bookingsController = Get.put(CustomerBookingsController());

  final scrollController = ScrollController();
  // final homeController = Get.find<HomeControllers>();

  Timer? _throttleTimer;
  bool showTopLoader = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels == 0) {
        _onTopReached();
      }
    });
  }

  void _onTopReached() {
    print("on Reached !!!!!!!!!!!!!!!!!!!");
    if (_throttleTimer?.isActive ?? false) return;

    setState(() => showTopLoader = true);

    bookingsController.refreshFetchBookings();

    _throttleTimer = Timer(const Duration(seconds: 2), () {
      setState(() => showTopLoader = false);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColor.whiteColor,
        toolbarHeight: 80,
        title: const Text(
          'Booked Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Obx(() {
          if (bookingsController.isLoading.value) {
            return const CustomerBookingsLoadingShimmer();
          } else {
            if (bookingsController.bookings.isEmpty) {
              return const Center(
                child: EmptyBookingsWidget(),
              ); // Show loader while fetching
            } else {
              // Horizontal List of Services
              return Stack(
                children: [
                  ListView.builder(
                    controller: scrollController,
                    itemCount: bookingsController.bookings.length,
                    itemBuilder: (context, index) {
                      final service = bookingsController.bookings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.whiteColor,
                          border: Border.all(
                            width: 1,
                            color: AppColor.inactiveColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.1), // Shadow color with transparency
                              blurRadius: 8, // Spread or softness of the shadow
                              offset: const Offset(
                                  0, 4), // Horizontal and vertical offset
                              spreadRadius: 2, // How far the shadow spreads
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Service title, distance, and price
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          text: service['serviceId']
                                              ["serviceName"],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: TextWidget(
                                                text:
                                                    "${service['serviceLocation']["street"]}, ${service['serviceLocation']["state"]}, ${service['serviceLocation']["country"]}",
                                                color: Colors.grey,
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatAsMoney(double.parse(
                                            service['serviceId']["servicePrice"]
                                                .toString())),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primaryColor,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatDate(service['createdAt']),
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              // Status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 25,
                                      height: 1,
                                      color: AppColor.inactiveColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    service['status'],
                                    style: TextStyle(
                                      color: service["status"] == "Pending"
                                          ? Colors.yellow.shade700
                                          : service["status"] == "Upcoming"
                                              ? AppColor.blueColor1
                                              : service["status"] == "Ongoing"
                                                  ? AppColor.darkBlueColor
                                                  : service["status"] ==
                                                          "Completed"
                                                      ? AppColor.greenColor
                                                      : service["status"] ==
                                                                  "Completed" ||
                                                              service["status"] ==
                                                                  "Verified"
                                                          ? AppColor
                                                              .primaryColor
                                                          : AppColor.redColor1,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 25,
                                      height: 1,
                                      color: AppColor.inactiveColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),

                              // User details
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage: CachedNetworkImageProvider(
                                      service["providerId"]["imageUrl"],
                                      errorListener: (error) => const Icon(
                                        Icons.person,
                                        color: AppColor.whiteColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service['providerId']["fullName"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        service['providerId']["businessName"],
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // View Details button
                              AppPrimaryButton(
                                buttonText: "View Details",
                                onPressed: () {
                                  Get.to(() => BookedServiceDetailsScreen(
                                            service: service,
                                          ))!
                                      .then((_) {
                                    Get.find<CustomerBookingsController>()
                                        .refreshFetchBookings();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  bookingsController.isRefreshLoading.value == true
                      ? const Positioned(
                          top: 20,
                          left: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColor.whiteColor,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: CircularProgressIndicator(
                                color: AppColor.primaryColor,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            }
          }
        }),
      ),
    );
  }
}
