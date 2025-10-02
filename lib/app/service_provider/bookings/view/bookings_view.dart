import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/bookings/controller/bookings_controller.dart';
import 'package:Victhon/app/service_provider/bookings/widget/bookings_loading_shimmer.dart';
import 'package:Victhon/app/service_provider/bookings/widget/empty_bookings_state.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/bookings/view/bookings_details.dart';
import 'package:Victhon/app/service_provider/bookings/widget/date_filter_dialog.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../utils/functions.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  // final bookingsController = Get.put(BookingsController());

  int selectedTabIndex = 0;

  final List<String> tabs = [
    "All",
    "Pending",
    "Upcoming",
    "Ongoing",
    "Completed",
    "Declined"
  ];

  bool availabilityStatus = false;

  final scrollController = ScrollController();
  final bookingsController = Get.find<BookingsController>();

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

    bookingsController.fetchBookings();

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
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColor.whiteColor,
        title: const Text(
          'Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showFilterDialog(context);
            },
            child: const Row(
              children: [
                Icon(Icons.calendar_today, color: AppColor.darkBlueColor),
                SizedBox(width: 4),
                Text(
                  'Select Date',
                  style: TextStyle(color: AppColor.darkBlueColor),
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: // Bookings List

            Column(
          children: [
            // Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                  itemCount: tabs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: buildTab(index),
                    );
                  }),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (bookingsController.isLoading.isTrue) {
                return const BookingsLoadingShimmer();
              } else {
                if (bookingsController.bookings.isEmpty) {
                  return const EmptyBookingsState(); // Show loader while fetching
                } else {
                  return tabview();
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  tabview() {
    if (selectedTabIndex == 0) {
      return bookingsController.bookings.isEmpty
          ? const EmptyBookingsState()
          : Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: scrollController,
                    itemCount: bookingsController.bookings.length,
                    itemBuilder: (context, index) {
                      return buildBookingCard(
                        bookingsController.bookings[index],
                        bookingsController.bookings[index]["customerId"] == null
                            ? "Unknown User"
                            : bookingsController.bookings[index]["customerId"]
                                ["fullName"],
                        bookingsController.bookings[index]["serviceId"]
                            ["serviceName"],
                        bookingsController.bookings[index]["status"],
                        bookingsController.bookings[index]["status"] ==
                                "Pending"
                            ? Colors.yellow.shade700
                            : bookingsController.bookings[index]["status"] ==
                                    "Upcoming"
                                ? AppColor.blueColor1
                                : bookingsController.bookings[index]
                                            ["status"] ==
                                        "Ongoing"
                                    ? AppColor.darkBlueColor
                                    : bookingsController.bookings[index]
                                                ["status"] ==
                                            "Completed"
                                        ? AppColor.greenColor
                                        : bookingsController.bookings[index]
                                                        ["status"] ==
                                                    "Completed" ||
                                                bookingsController
                                                            .bookings[index]
                                                        ["status"] ==
                                                    "Verified"
                                            ? AppColor.primaryColor
                                            : AppColor.redColor1,
                      );
                    },
                  ),
                  //       if (showTopLoader)
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: Container(
                  //     height: 60,
                  //     color: Colors.white,
                  //     alignment: Alignment.center,
                  //     child: const CircularProgressIndicator(),
                  //   ),
                  // ),
                ],
              ),
            );
    } else if (selectedTabIndex == 1) {
      return bookingsController.pendingBookings.isEmpty
          ? const EmptyBookingsState(status: 'Pending')
          : Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: bookingsController.pendingBookings.length,
                itemBuilder: (context, index) {
                  return buildBookingCard(
                    bookingsController.pendingBookings[index],
                    bookingsController.pendingBookings[index]["customerId"]
                        ["fullName"],
                    bookingsController.pendingBookings[index]["serviceId"]
                        ["serviceName"],
                    bookingsController.pendingBookings[index]["status"],
                    Colors.yellow.shade700,
                  );
                },
              ),
            );
    } else if (selectedTabIndex == 2) {
      return bookingsController.upcomingBookings.isEmpty
          ? const EmptyBookingsState(status: 'Upcoming')
          : Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: bookingsController.upcomingBookings.length,
                itemBuilder: (context, index) {
                  return buildBookingCard(
                    bookingsController.upcomingBookings[index],
                    bookingsController.upcomingBookings[index]["customerId"]
                        ["fullName"],
                    bookingsController.upcomingBookings[index]["serviceId"]
                        ["serviceName"],
                    bookingsController.upcomingBookings[index]["status"],
                    AppColor.blueColor1,
                  );
                },
              ),
            );
    } else if (selectedTabIndex == 3) {
      return bookingsController.ongoingBookings.isEmpty
          ? const EmptyBookingsState(status: 'Ongoing')
          : Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: bookingsController.ongoingBookings.length,
                itemBuilder: (context, index) {
                  return buildBookingCard(
                    bookingsController.ongoingBookings[index],
                    bookingsController.ongoingBookings[index]["customerId"]
                        ["fullName"],
                    bookingsController.ongoingBookings[index]["serviceId"]
                        ["serviceName"],
                    bookingsController.ongoingBookings[index]["status"],
                    AppColor.darkBlueColor,
                  );
                },
              ),
            );
    } else if (selectedTabIndex == 4) {
      return bookingsController.completedBookings.isEmpty
          ? const EmptyBookingsState(status: 'Completed')
          : Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: bookingsController.completedBookings.length,
                itemBuilder: (context, index) {
                  return buildBookingCard(
                    bookingsController.completedBookings[index],
                    bookingsController.completedBookings[index]["customerId"]
                        ["fullName"],
                    bookingsController.completedBookings[index]["serviceId"]
                        ["serviceName"],
                    bookingsController.completedBookings[index]["status"],
                    AppColor.greenColor,
                  );
                },
              ),
            );
    } else if (selectedTabIndex == 5) {
      return bookingsController.declinedBookings.isEmpty
          ? const EmptyBookingsState(status: 'Declined')
          : Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: bookingsController.declinedBookings.length,
                itemBuilder: (context, index) {
                  return buildBookingCard(
                    bookingsController.declinedBookings[index],
                    bookingsController.declinedBookings[index]["customerId"]
                        ["fullName"],
                    bookingsController.declinedBookings[index]["serviceId"]
                        ["serviceName"],
                    bookingsController.declinedBookings[index]["status"],
                    AppColor.redColor1,
                  );
                },
              ),
            );
    }
  }

  Widget buildTab(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          bookingsController.fetchBookings();

          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedTabIndex == index
              ? AppColor.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          tabs[index],
          style: TextStyle(
            color: selectedTabIndex == index ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildBookingCard(
    Map bookingDetails,
    String name,
    String service,
    String status,
    Color statusColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: AppColor.primaryCardColor,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bookingDetails["customerId"] == null
                    ? CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          color: AppColor.whiteColor,
                        ),
                      )
                    : CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColor.primaryColor.shade100,
                        child: ClipOval(
                          child: CachedNetworkImage(
                              imageUrl: bookingDetails["customerId"]
                                  ["imageUrl"],
                              fit: BoxFit.cover,
                              width: 44,
                              height: 44,
                              errorWidget: (context, url, error) => const Icon(
                                    Icons.person,
                                    color: AppColor.whiteColor,
                                    size: 28,
                                  ),
                              placeholder: (context, url) => const SizedBox()),
                        ),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: name,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        text: service,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 20,
                            color: AppColor.blackColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextWidget(
                              text: formatDate(bookingDetails["createdAt"]),
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_outlined,
                            size: 18,
                            color: AppColor.blackColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formatAsMoney(
                              double.parse(bookingDetails["serviceId"]
                                      ["servicePrice"]
                                  .toString()),
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: AppColor.blackColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextWidget(
                              text: bookingDetails
                                          .containsKey("serviceLocation") &&
                                      bookingDetails["serviceLocation"] is Map
                                  ? "${bookingDetails["serviceLocation"]["street"]}, ${bookingDetails["serviceLocation"]["state"]}, ${bookingDetails["serviceLocation"]["country"]}"
                                  : "Not available",
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextWidget(
                    text: status,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(
            color: AppColor.primaryColor.shade50,
            height: 1,
          ),
          const SizedBox(height: 8),
          // if (status == "Pending")
          //   Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Expanded(
          //           child: AppPrimaryButton(
          //             buttonText: "View Details",
          //             onPressed: () {
          //               Get.to(() => BookingDetailsScreen(
          //                         status: status,
          //                         statusColor: statusColor,
          //                         bookingDetails: bookingDetails,
          //                       ))!
          //                   .then((_) {
          //                 Get.find<BookingsController>().fetchBookings();
          //               });
          //             },
          //             buttonColor: AppColor.whiteColor,
          //             textColor: AppColor.primaryColor,
          //           ),
          //         ),
          //         const SizedBox(
          //           width: 16,
          //         ),
          //         Expanded(
          //           child: AppPrimaryButton(
          //             buttonText: "Accept",
          //             onPressed: () {},
          //           ),
          //         )
          //       ],
          //     ),
          //   )
          // else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: AppPrimaryButton(
              buttonText: "View Details",
              onPressed: () {
                Get.to(() => BookingDetailsScreen(
                          status: status,
                          statusColor: statusColor,
                          bookingDetails: bookingDetails,
                        ))!
                    .then((_) {
                  Get.find<BookingsController>().fetchBookings();
                });
              },
              buttonColor: AppColor.whiteColor,
              textColor: AppColor.primaryColor,
            )),
          ),
        ],
      ),
    );
  }
}
