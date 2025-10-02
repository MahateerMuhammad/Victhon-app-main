import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/bookings/controller/bookings_controller.dart';
import 'package:Victhon/app/customerApp/bookings/widget/cancellation_reason_bottom_sheet.dart';
import 'package:Victhon/app/customerApp/bookings/widget/rating_review_bottom_sheet.dart';
import 'package:Victhon/app/customerApp/bookings/widget/report_service_bottom_sheet.dart';
import 'package:Victhon/app/customerApp/inbox/controller/inbox_controller.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/functions.dart';
import '../../../../widget/textwidget.dart';
import '../../inbox/view/chat_screen_view.dart';

class BookedServicesDetailsComponent extends StatelessWidget {
  BookedServicesDetailsComponent({
    super.key,
    required this.service,
  });
  final Map service;

  final bookingsController = Get.put(CustomerBookingsController());
  final inboxController = Get.put(InboxController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                      text: service["requestId"],
                      fontSize: 16,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.green),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: service["requestId"]));
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
          Row(
            children: [
              CircleAvatar(
                radius: 22,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: service['providerId']["fullName"],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      text: service['providerId']["businessName"],
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColor.yellowGold,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  TextWidget(
                    text: "${service['providerId']["rating"]}",
                    fontSize: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "Booking Information",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildInfoCard(),
          const SizedBox(
            height: 16,
          ),
          service["status"] == "Completed" || service["status"] == "Verified"
              ? GestureDetector(
                  onTap: () {
                    showRatingReviewBottomSheet(
                      context,
                      service["_id"],
                    );
                  },
                  child: const TextWidget(
                    text: "Rate And Review Provider",
                    color: AppColor.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 80,
          ),
          service["status"] == "Completed" || service["status"] == "Verified"
              ? const SizedBox()
              : service["status"] == "Cancelled"
                  ? const SizedBox() // Reschedule option
                  : SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Find existing conversation with this service provider
                          final inboxController = Get.find<InboxController>();
                          final serviceProviderId = service["providerId"]["userId"];
                          
                          // Look for existing conversation
                          dynamic existingConversation;
                          for (var conversation in inboxController.conversationDetails) {
                            if (conversation["otherUser"]["userId"] == serviceProviderId) {
                              existingConversation = conversation;
                              break;
                            }
                          }
                          
                          // Navigate with existing conversation or new chat
                          Get.to(() => ChatScreen(
                                message: existingConversation,
                                serivceProviderDetails: service["providerId"],
                              ))!
                              .then((_) {
                            inboxController.refreshConversationsOnly();
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.chat_bubble_text,
                          color: AppColor.primaryColor,
                        ),
                        label: const TextWidget(
                          text: "Chat With Service Provider",
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
          const SizedBox(
            height: 16,
          ),
          service["status"] == "Upcoming"
              ? AppPrimaryButton(
                  buttonText: "Pay ${formatAsMoney(
                    double.parse(
                        service["serviceId"]["servicePrice"].toString()),
                  )}",
                  onPressed: () {
                    bookingsController.payForBooking(service["_id"]);
                  },
                )
              : const SizedBox(),
          service["status"] == "Verified"
              ? const SizedBox()
              : Row(
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        buttonText: "Report Issue",
                        borderColor: AppColor.primaryColor,
                        textColor: AppColor.primaryColor,
                        onPressed: () {
                          showReportServiceBottomSheet(
                            context,
                            service["_id"],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: AppPrimaryButton(
                        buttonText: "Confirm",
                        onPressed: () {
                          bookingsController.confirmBookingCompletion(
                              service["_id"], context);
                        },
                      ),
                    ),
                  ],
                ),
          service["status"] == "Cancelled" ||
                  service["status"] == "Completed" ||
                  service["status"] == "Verified"
              ? const SizedBox()
              : Center(
                  child: TextButton(
                    onPressed: () {
                      showCancellationReasonBottomSheet(
                          context, service["_id"]);
                      // Handle cancel request action
                    },
                    child: const Text(
                      "Cancel Request",
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.redColor1,
                      ),
                    ),
                  ),
                ),
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
          _buildInfoRow("Service", service["serviceId"]["serviceName"]),
          _buildInfoRow("Date", formatDate(service["createdAt"])),
          _buildInfoRow(
            "Status",
            service["status"],
            trailingWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: service["status"] == "Pending"
                    ? Colors.yellow.shade700
                    : service["status"] == "Upcoming"
                        ? AppColor.blueColor1
                        : service["status"] == "Ongoing"
                            ? AppColor.darkBlueColor
                            : service["status"] == "Completed"
                                ? AppColor.greenColor
                                : service["status"] == "Completed" ||
                                        service["status"] == "Verified"
                                    ? AppColor.primaryColor
                                    : AppColor.redColor1,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                service["status"],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // _buildInfoRow("Booking ID", "123456"),
          _buildInfoRow(
            "Price",
            formatAsMoney(
              double.parse(service["serviceId"]["servicePrice"].toString()),
            ),
          ),
          _buildInfoRow("Payment Type", "Cash"),
          _buildInfoRow(
            "Location",
            "${service["serviceLocation"]["street"]}, ${service["serviceLocation"]["state"]}, ${service["serviceLocation"]["country"]}",
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
