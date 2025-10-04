import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/bookings/controller/bookings_controller.dart';
import 'package:Victhon/app/service_provider/messages/view/chat_screen_view.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/bookings/widget/cancel_dialog.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/loader.dart';

class BookingDetailsScreen extends StatelessWidget {
  BookingDetailsScreen({
    super.key,
    required this.status,
    required this.statusColor,
    required this.bookingDetails,
  });
  final String status;
  final Color statusColor;
  final Map bookingDetails;

  final bookingsController = Get.put(BookingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              title: const Text(
                "Booking Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              surfaceTintColor: AppColor.whiteColor,
              backgroundColor: AppColor.whiteColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Information
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundYellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        const TextWidget(
                          text: 'Booking ID',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: bookingDetails["requestId"],
                              fontSize: 16,
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.green),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: bookingDetails["requestId"]));
                                Get.snackbar('Copied', 'Transaction ID copied');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Booking Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(),

                  const SizedBox(height: 20),

                  // Notes Section
                  const Text(
                    "Notes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildNotesCard(),

                  const SizedBox(height: 20),

                  // Customer Information
                  const Text(
                    "Customer Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  bookingDetails["customerId"] == null
                      ? const SizedBox()
                      : _buildCustomerInfo(),

                  const SizedBox(height: 20),

                  // Start Service Button
                  status == "Completed" ||
                          status == "Declined" ||
                          bookingDetails["customerId"] == null
                      ? const SizedBox()
                      : status == "Pending"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AppOutlinedButton(
                                    buttonText: "Decline",
                                    onPressed: () {
                                      showCancelBookingDialog(context);
                                    },
                                    borderColor: AppColor.primaryColor,
                                    textColor: AppColor.primaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: AppPrimaryButton(
                                    buttonText: "Accept",
                                    onPressed: () {
                                      bookingsController.acceptBookings(
                                        bookingDetails["_id"],
                                        context,
                                      );
                                    },
                                  ),
                                )
                              ],
                            )
                          : AppPrimaryButton(
                              buttonText: status == "Upcoming"
                                  ? "Start Service"
                                  : status == "Ongoing"
                                      ? "Complete Service"
                                      : "",
                              onPressed: () {
                                if (status == "Upcoming") {
                                  bookingsController.startBookings(
                                    bookingDetails["_id"],
                                    context,
                                  );
                                } else if (status == "Ongoing") {
                                  bookingsController.completeBookings(
                                    bookingDetails["_id"],
                                    context,
                                  );
                                }
                              },
                            ),
                  const SizedBox(
                    height: 24,
                  )
                ],
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

  // Booking Information Card
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Service", bookingDetails["serviceId"]["serviceName"]),
          _buildInfoRow("Date", formatDate(bookingDetails["createdAt"])),
          _buildInfoRow(
            "Status",
            status,
            trailingWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // _buildInfoRow("Booking ID", "123456"),
          _buildInfoRow(
            "Price",
            formatAsMoney(
              double.parse(
                  bookingDetails["serviceId"]["servicePrice"].toString()),
            ),
          ),
          _buildInfoRow(
            "Location",
            "${bookingDetails["serviceLocation"]["street"]}, ${bookingDetails["serviceLocation"]["state"]}, ${bookingDetails["serviceLocation"]["country"]}",
          ),
          const SizedBox(
            height: 8,
          ),
          // InkWell(
          //   onTap: () {},
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: Column(
          //       children: [
          //         const TextWidget(
          //           text: "Open Map",
          //           fontSize: 12,
          //           color: AppColor.darkBlueColor,
          //           fontWeight: FontWeight.w500,
          //         ),
          //         Container(
          //           height: 0.5,
          //           width: 60,
          //           color: AppColor.darkBlueColor,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Notes Section
  Widget _buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextWidget(
        text: bookingDetails["message"],
        fontSize: 16,
      ),
    );
  }

  // Customer Information Section
  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            "Name",
            bookingDetails["serviceId"]["serviceName"],
            trailingWidget: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColor.primaryColor.shade100,
                  child: ClipOval(
                    child: CachedNetworkImage(
                        imageUrl: bookingDetails["customerId"]["imageUrl"],
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
                const SizedBox(
                  width: 8,
                ),
                TextWidget(
                  text: bookingDetails["customerId"]["fullName"],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )
              ],
            ),
          ),
          _buildInfoRow("Contact", bookingDetails["customerId"]["phone"]),
          _buildInfoRow("Email", bookingDetails["customerId"]["email"]),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton.icon(
              onPressed: () {
                // Navigate directly to chat screen with this specific customer
                // Create a mock conversation object for the chat screen
                final customerConversation = {
                  "_id": null, // Will be a new conversation if no existing one
                  "otherUser": {
                    "userId": bookingDetails["customerId"]["_id"],
                    "fullName": bookingDetails["customerId"]["fullName"],
                    "imageUrl": bookingDetails["customerId"]["imageUrl"] ?? "",
                  },
                  "messages": [], // Empty messages array for new conversation
                };

                Get.to(() => ServiceProviderChatScreen(
                  message: customerConversation,
                ));
              },
              icon: const Icon(
                CupertinoIcons.chat_bubble_text,
                color: AppColor.primaryColor,
              ),
              label: const TextWidget(
                text: "Chat With Customer",
                color: AppColor.primaryColor,
                fontSize: 14,
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColor.whiteColor,
                side: const BorderSide(
                  color: AppColor.primaryColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build information rows
  Widget _buildInfoRow(String title, String value, {Widget? trailingWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title on the left
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            width: 16,
          ),

          // Right side text or widget that wraps
          Flexible(
            child: trailingWidget ??
                Text(
                  value,
                  textAlign: TextAlign.right,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
