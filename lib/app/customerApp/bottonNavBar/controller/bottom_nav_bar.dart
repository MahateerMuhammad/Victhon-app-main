import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';

class BottomNavBarController extends GetxController {

  sendOneSignalPlayerId(playerId) async {
    print("************** sendOneSignalPlayerId");
    final ApiResponse response = await RemoteServices()
        .sendOneSignalPlayerId(oneSignalPlayerId: playerId);
      debugPrint("✅ FCM token registered: ${response.data}");

    if (response.isSuccess) {
      // ✅ Extracting data from the response

      final dynamic responseData = response.data;
      
      // Check if notification preferences exist first
      final getNotifiResponse = await RemoteServices().getNotifiPreference();
      if (getNotifiResponse == null) {
        // Preferences don't exist, create them with default false values
        final notifiResponse = await RemoteServices().createNotifiPreference();
        if (notifiResponse != null) {
          debugPrint("✅ Customer notification preferences created with default false values");
        } else {
          debugPrint("❌ Failed to create customer notification preferences");
        }
      } else {
        debugPrint("✅ Customer notification preferences already exist");
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
