import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:Victhon/config/routes/app_routes.dart';

class OnesignalNotificationService {
  static Future<void> init() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("40d2902c-6e82-460a-8dd4-502e7c741a6f");

        // Foreground handler
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint("🔔 Foreground notification: ${event.notification.title}");
      event.notification; // show it manually
    });

    // Handle notification tap
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.title;

      debugPrint("🔔 Notification tapped with data: $data");

      // Navigate using GetX
      if (data != null) {
        Get.toNamed(Routes.customerNotificationsScreen, arguments: data);
      }
    });

   OneSignal.User.pushSubscription.addObserver((subscription) {
    print("################# $subscription ");
  if (subscription.current.id != null) {
    debugPrint("📲 pushSubscription.id is now available: ${subscription.current.id}");
    // sendOneSignalPlayerId(subscription.id!);
  }
});

  }
}

Future<void> requestNotificationPermissionIfNotGranted() async {
  OneSignal.Notifications.addPermissionObserver((permission) {
    debugPrint("🔔 Notifications permission status: ${permission}");

  if (!permission) {
    OneSignal.Notifications.requestPermission(true);
    Get.snackbar('Permission Required', 'Please enable notifications in settings.');

  } 
  //else if (!permission.subscriptionStatus.permissionStatus.status) {
  //   // Show a custom UI to inform the user to enable permissions from settings
  // }
  },);


}

