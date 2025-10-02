import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/bookings/controller/bookings_controller.dart';
import 'package:Victhon/app/customerApp/home/controller/home_controllers.dart';
import 'package:Victhon/app/customerApp/inbox/controller/inbox_controller.dart';
import 'package:Victhon/app/customerApp/profile/controller/profile_controller.dart';
import 'package:Victhon/app/service_provider/bookings/controller/bookings_controller.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:Victhon/app/service_provider/earnings/controller/earnings_controller.dart';
import 'package:Victhon/app/service_provider/profile/controller/service_provider_profile_controller.dart';
import '../../app/service_provider/dashboard/controller/dashboard_controller.dart';
import '../../main.dart';

class NetworkService extends GetxService {
  final InternetConnectionChecker _connectivity = InternetConnectionChecker();
  final isConnected = true.obs;
  final showRestoredMessage = false.obs;

  late final StreamSubscription<InternetConnectionStatus> _subscription;

  Future<NetworkService> init() async {
    debugPrint("---------- Network onInit");

    // _checkInitialConnection();
    _subscription = _connectivity.onStatusChange.listen((status) {
      debugPrint("----------- Update status: $status");
      // if(!isConnected.value)
      isConnected.value = status == InternetConnectionStatus.connected;
      if (box.read("authStatus") == "loggedIn") {
        if (isConnected.value) {
          showRestoredMessage.value = true;

          Future.delayed(const Duration(seconds: 2), () {
            showRestoredMessage.value = false;
          });

          _onNetworkRestored();
        } else if (!isConnected.value) {
          showRestoredMessage.value = true;

          Future.delayed(const Duration(seconds: 5), () {
            showRestoredMessage.value = false;
          });
        }
      }

      debugPrint("Internet status updated: $isConnected");
    });

    return this;
  }

  void _onNetworkRestored() {
    debugPrint("Network restored --------------");
    // Call all necessary controllers here
    try {
      if (box.read("userType") == "customer") {
        Get.find<HomeControllers>().fetchServices();
        Get.find<ProfileController>().fetchProfile();
        Get.find<InboxController>().fetchConversation();
        Get.find<CustomerBookingsController>().fetchBookings();
      } else {
        Get.find<DashboardController>().fetchDashboard();
        Get.find<BookingsController>().fetchBookings();
        Get.find<EarningsController>().fetchTransaction();
        Get.find<ServiceProviderProfileController>().fetchProfile();
      }

      // Add other controller refreshes here...
    } catch (e) {
      debugPrint("Error refreshing controllers: $e");
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
