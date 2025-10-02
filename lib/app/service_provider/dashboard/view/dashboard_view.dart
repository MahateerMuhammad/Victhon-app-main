import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/dashboard/controller/dashboard_controller.dart';
import 'package:Victhon/app/service_provider/services/view/services_list.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/services/view/add_service_stage1.dart';
import 'package:Victhon/app/service_provider/messages/view/messages_view.dart';
import 'package:Victhon/app/service_provider/notifications/view/notification_view.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../widget/dashboard_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // final dashboardController = Get.put(DashboardController());

  // bool isRegularUser = false;
  bool availabilityStatus = false;

  final scrollController = ScrollController();
  final dashboardController = Get.find<DashboardController>();

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
    if (_throttleTimer?.isActive ?? false) return;

    setState(() => showTopLoader = true);

    dashboardController.fetchDashboard();

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: AppColor.whiteColor,
        toolbarHeight: 60,
        elevation: 0,
        leading: Obx(() {
          if (dashboardController.dashboardDetails.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade300,
              ),
            ); // Show loader while fetching
          } else {
            return dashboardController.dashboardDetails["profileImage"] == null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: CachedNetworkImageProvider(
                        dashboardController.dashboardDetails["profileImage"],
                        errorListener: (error) => const Icon(
                          Icons.person,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  );
          }
        }),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (dashboardController.dashboardDetails.isEmpty) {
                return const SizedBox(); // Show loader while fetching
              } else {
                // Horizontal List of Services
                return TextWidget(
                  text:
                      'Welcome ${dashboardController.dashboardDetails["name"]}',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                );
              }
            }),
            const SizedBox(
              height: 4,
            ),
            const Text(
              "Here's what's happening today.",
              style: TextStyle(
                color: AppColor.blackColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => ServiceProviderMessagesScreen());
            },
            child: const Icon(CupertinoIcons.chat_bubble_text,
                color: AppColor.primaryColor),
          ),
          const SizedBox(width: 10),
          InkWell(
              onTap: () {
                Get.to(() => NotificationView());
              },
              child: const Icon(CupertinoIcons.bell,
                  color: AppColor.primaryColor)),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Obx(() {
                    if (dashboardController.services.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: [
                            const TextWidget(
                              text: "Availability Status",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 35,
                              width: 45,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Switch(
                                    value: availabilityStatus,
                                    activeColor: AppColor.whiteColor,
                                    activeTrackColor: AppColor.blueBorderColor,
                                    inactiveTrackColor:
                                        AppColor.primaryColor.shade100,
                                    inactiveThumbColor: AppColor.whiteColor,
                                    // Removing the focus/outline
                                    focusColor: Colors.transparent,
                                    trackOutlineColor:
                                        MaterialStateProperty.all(
                                            Colors.transparent),
                                    onChanged: (value) {
                                      setState(() {
                                        availabilityStatus = value;
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ); // Show loader while fetching
                    } else {
                      return const SizedBox();
                    }
                  }),
                  Obx(() {
                    if (dashboardController.services.isNotEmpty) {
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => ServicesList())!
                              .then((_) {
                            Get.find<DashboardController>().fetchDashboard();
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.pencil_outline,
                          color: Colors.white,
                        ),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Text(
                            'Manage Services',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                      // return Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width / 2 - 24,
                      //   // height: 40,
                      //   child: OutlinedButton.icon(
                      //     style: OutlinedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       side:
                      //           const BorderSide(color: AppColor.primaryColor),
                      //     ),
                      //     onPressed: () {
                      //       Get.to(() => const SetAvailability(
                      //             availabilityHeader: "Manage Availability",
                      //           ));
                      //     },
                      //     icon: const Icon(
                      //       CupertinoIcons.calendar,
                      //       color: AppColor.primaryColor,
                      //     ),
                      //     label: const Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 8,
                      //         vertical: 6,
                      //       ),
                      //       child: Text(
                      //         'Manage Availability',
                      //         style: TextStyle(
                      //           color: AppColor.primaryColor,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width / 2 - 24,
                      //   child: ElevatedButton.icon(
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColor.primaryColor,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       Get.to(() => ServicesList(
                      //             services: dashboardController.services,
                      //           ));
                      //     },
                      //     icon: const Icon(
                      //       CupertinoIcons.pencil_outline,
                      //       color: Colors.white,
                      //     ),
                      //     label: const Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 8,
                      //         vertical: 6,
                      //       ),
                      //       child: Text(
                      //         'Manage Services',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      //   ],
                      // );
                    } else {
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const AddServiceStage1())!.then((_) {
                            Get.find<DashboardController>().fetchDashboard();
                          });
                        },
                        icon: const Icon(CupertinoIcons.pencil_outline,
                            color: Colors.white),
                        label: const Text(
                          'Add Service',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  }),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (dashboardController.dashboardDetails.isEmpty) {
                      return ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                  color: AppColor.primaryCardColor,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                      ); // Show loader while fetching
                    } else {
                      // Horizontal List of Services
                      return Column(
                        children: [
                          DashboardCard(
                            title: 'Total Earnings',
                            value: formatAsMoney(double.parse(
                                dashboardController
                                    .dashboardDetails["totalEarnings"]
                                    .toString())),
                            icon: Icons.wallet,
                            iconColor: AppColor.blueColor1,
                          ),
                          DashboardCard(
                            title: 'Total Bookings',
                            value:
                                '${dashboardController.dashboardDetails["totalBookings"]}',
                            icon: Icons.date_range_rounded,
                            iconColor: AppColor.primaryColor.shade200,
                          ),
                          DashboardCard(
                              title: 'Total Reviews',
                              value:
                                  '${dashboardController.dashboardDetails["totalReviews"]}',
                              icon: Icons.chat_rounded,
                              iconColor: AppColor.blueBorderColor),
                          DashboardCard(
                              title: 'Average Rating',
                              value:
                                  '${dashboardController.dashboardDetails["averageRating"]}',
                              icon: Icons.star_half_rounded,
                              iconColor: Colors.yellow),
                        ],
                      );
                    }
                  })
                ],
              ),
            ),
          ),
          if (showTopLoader)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                color: Colors.white,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
