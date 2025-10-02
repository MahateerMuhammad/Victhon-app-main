import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/messages/view/messages_view.dart';
import 'package:Victhon/app/service_provider/notifications/controller/notifications_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/notifications/view/notification_off_view.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../bottomNavBar/controller/service_provider_bottom_nav_bar_controller.dart';
import '../../ratings/view/ratings_view.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});
  final notificationsController = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        surfaceTintColor: AppColor.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const TextWidget(
          text: "Notifications",
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (notificationsController.isLoading.value) {
          return const SizedBox();
        } else {
          if (notificationsController.notifications.isEmpty) {
            return const Center(
              child: NotificationOffView(),
            ); // Show loader while fetching
          } else {
            // Horizontal List of Services
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notificationsController.notifications.length,
              itemBuilder: (context, index) {
                final item = notificationsController.notifications[index];
                return NotificationTile(
                  title: item["title"],
                  subtitle: item["message"],
                  type: item["type"],
                  time: item["createdAt"],
                  isRead: item["read"],
                  senderImageUrl: item["senderImageUrl"],
                );
              },
            );
          }
        }
      }),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String type;
  final String time;
  final bool isRead;
  final String? senderImageUrl;

  const NotificationTile({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.time,
    required this.isRead,
    this.senderImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (type == "Booking") {
          Get.back();
          Get.find<ServiceProviderBottomNavBarController>()
              .changeTab(1); // Switch to "Earnings" tab
        } else if (type == "Review") {
          Get.back();
          Get.to(() => RatingsView());
        } else if (type == "Chat") {
          Get.back();
          Get.to(() => ServiceProviderMessagesScreen());
        } else if (type == "Payment") {
          Get.back();
          Get.find<ServiceProviderBottomNavBarController>().changeTab(2);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColor.primaryCardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            type == "Booking"
                ? CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColor.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppIcons.calendarIcon,
                        color: AppColor.primaryColor,
                      ),
                    ), // Replace with actual avatar
                  )
                : type == "Review"
                    ? const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColor.whiteColor,
                        child: Icon(
                          Icons.star,
                          size: 30,
                          color: AppColor.yellowGold,
                        ), // Replace with actual avatar
                      )
                    : type == "Chat"
                        ? CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: CachedNetworkImageProvider(
                              senderImageUrl ?? '',
                              errorListener: (error) => const Icon(
                                Icons.person,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColor.whiteColor,
                            child: Image.asset(
                              AppIcons.walletIcon,
                              color: AppColor.primaryColor,
                            ), // Replace with actual avatar
                          ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatChatTimestamp(time),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  if (!isRead)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.circle,
                        color: AppColor.primaryColor,
                        size: 14,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
