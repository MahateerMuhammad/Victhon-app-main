import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../main.dart';

class DashboardController extends GetxController {
  final isLoading = false.obs;
  var remainingTimerTime = 5.obs;
  Timer? timer;

  RxMap<String, dynamic> dashboardDetails =
      <String, dynamic>{}.obs; // Stores services
  RxList services = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    print("heyyyyyyyy fetch dashboardDetails");
    prefs = await SharedPreferences.getInstance();
    
    String? savedDashboardDetails = prefs.getString("cached_dashboard");
    if (savedDashboardDetails != null) {
      dashboardDetails.value =
          Map<String, dynamic>.from(json.decode(savedDashboardDetails));
      services.value = dashboardDetails["services"];

    }
    // Fetch new services from API

    final response = await RemoteServices().getDashboard();
    // print("@@@@@@@@@@ ${response} @@@@@@@@@@");
    // print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    // print("@@@@@@@@@@ ${response.statusCode} @@@@@@@@@@");

    if (response is Map<String, dynamic>) {
      dashboardDetails.value = response;
      services.value = response["services"];
      await prefs.setString("cached_dashboard", json.encode(response));
    } else {
          // // Check if services exist in local storage
    String? savedDashboardDetails = prefs.getString("cached_dashboard");
    if (savedDashboardDetails != null) {
      dashboardDetails.value =
          Map<String, dynamic>.from(json.decode(savedDashboardDetails));
      services.value = dashboardDetails["services"];

    }
    }
  }
}
