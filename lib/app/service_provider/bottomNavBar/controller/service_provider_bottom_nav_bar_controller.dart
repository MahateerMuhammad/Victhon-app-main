import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../service_provider/bookings/controller/bookings_controller.dart';
import '../../../service_provider/dashboard/controller/dashboard_controller.dart';
import '../../../service_provider/earnings/controller/earnings_controller.dart';
import '../../../service_provider/profile/controller/service_provider_profile_controller.dart';

class ServiceProviderBottomNavBarController extends GetxController {
  final dashboardController = Get.put(DashboardController());
  final bookingsController = Get.put(BookingsController());
  final earningsController = Get.put(EarningsController());
  final providerProfileController = Get.put(ServiceProviderProfileController());
  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;

    if (selectedIndex == 0) {
      dashboardController.fetchDashboard();
    } else if (selectedIndex == 1) {
      bookingsController.fetchBookings();
    } else if (selectedIndex == 2) {
      earningsController.fetchTransaction();
    } else if (selectedIndex == 3) {
      providerProfileController.fetchProfile();
      providerProfileController.fetchNotifiPreference();
    }
  }

  sendOneSignalPlayerId(playerId) async {
    print("************** sendOneSignalPlayerId");
    final ApiResponse response = await RemoteServices()
        .sendOneSignalPlayerId(oneSignalPlayerId: playerId);
    debugPrint("✅ FCM token registered: ${response.data}");

    if (response.isSuccess) {
      // ✅ Extracting data from the response

      final dynamic responseData = response.data;
      final ApiResponse notifiResponse =
          await RemoteServices().createNotifiPreference();
      if (notifiResponse.isSuccess) {
        debugPrint("✅ Notification set : ${notifiResponse.data}");
      }

      print("Response Data: $responseData");
    } else {
      print("❌ --------- $response");
    }
  }

  notificationFunction() async {
    // Request user permission
    await OneSignal.Notifications.requestPermission(true);

    // Wait a moment to let OneSignal register the device
    await Future.delayed(Duration(seconds: 2));

    // Get correct Player ID (used with REST API)
    String? pushId = OneSignal.User.pushSubscription.id;
    debugPrint("📲 OneSignal pushSubscription.id: $pushId");

    // Optionally also log internal OneSignal ID
    String? userId = await OneSignal.User.getOnesignalId();
    debugPrint("🧠 OneSignal internal user ID: $userId");

    if (pushId != null) {
      sendOneSignalPlayerId(pushId); // Use this in your backend
    } else {
      debugPrint("❌ Player ID is still null. Try again later.");
    }
  }
}
