import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/notifications/controller/notification_controller.dart';
import 'package:Victhon/app/customerApp/notifications/view/customer_notification_off.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../utils/functions.dart';
import '../../../../utils/icons.dart';

class CustomerNotificationView extends StatelessWidget {
  CustomerNotificationView({super.key});

 
 final notificationsController = Get.put(CustomerNotificationsController());

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
              child: CustomerNotificationOffView(),
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
                  time: item["createdAt"],
                  isRead: item["read"],
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
  // final dynamic icon;
  final String time;
  final bool isRead;

  const NotificationTile({
    required this.title,
    required this.subtitle,
    // required this.icon,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title == "New Service Request"
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
    );
  }
}
