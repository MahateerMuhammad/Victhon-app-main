import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/remote_services/remote_services.dart';

class CustomerNotificationsController extends GetxController {
  final isLoading = false.obs;

  RxList<dynamic> notifications = <dynamic>[].obs; // Stores services


  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    print("heyyyyyyyy fetch fetchNotification");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedBookingsDetails = prefs.getString("cached_notifications");
    if (savedBookingsDetails != null) {
      notifications.value =
          List<dynamic>.from(json.decode(savedBookingsDetails)).toList();
    }

    // Fetch new services from API
    isLoading(true);

    final response = await RemoteServices()
        .getNotifications();
    print("@@@@@@@@@@ $response @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isLoading(false);
    if (response is List) {
      notifications.value = response;

      await prefs.setString(
          "cached_notifications", json.encode(response));
    }
  }

}