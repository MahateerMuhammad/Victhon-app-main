import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/server/app_server.dart';
import '../../../../widget/custom_snackbar.dart';
import '../widget/webview_widget.dart';

class CustomerBookingsController extends GetxController {
  final isLoading = false.obs;
  final isRefreshLoading = false.obs;
  var remainingTimerTime = 5.obs;
  Timer? timer;

  RxList<dynamic> bookings = <dynamic>[].obs; // Stores services
  var rating = 0.obs;
  final reviewCommentController = TextEditingController();
  final reportServiceController = TextEditingController();

  final reasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    print("heyyyyyyyy fetch fetchBookingsDetails");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedBookingsDetails = prefs.getString("cached_bookings");
    if (savedBookingsDetails != null) {
      bookings.value =
          List<dynamic>.from(json.decode(savedBookingsDetails)).toList();
    }

    // Fetch new services from API
    isLoading(true);

    final response = await RemoteServices()
        .getBookings(userType: "customer", bookingStatus: '');
    print("@@@@@@@@@@ $response @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isLoading(false);
    if (response is Map<String, dynamic>) {
      bookings.value = response["bookings"];

      await prefs.setString(
          "cached_bookings", json.encode(response["bookings"]));
    }
  }

  Future<void> refreshFetchBookings() async {
    print("heyyyyyyyy fetch fetchBookingsDetails");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch new services from API
    isRefreshLoading(true);

    final response = await RemoteServices()
        .getBookings(userType: "customer", bookingStatus: '');
    print("@@@@@@@@@@ $response @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isRefreshLoading(false);

    if (response is Map<String, dynamic>) {
      bookings.value = response["bookings"];

      await prefs.setString(
          "cached_bookings", json.encode(response["bookings"]));
    }
  }

  payForBooking(
    String bookingId,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().payForBooking(bookingId: bookingId);
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      Get.to(() => WebViewStack(
            url: responseData["data"]["authorization_url"],
          ));
    } else {
      print("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
      update();
      // });
    }
  }

  void openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void setRating(int value) {
    rating.value = value;
  }

  rateAndReviewService(
    String bookingId,
    int ratingValue,
    String reviewComment,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().rateAndReviewService(
      serviceId: bookingId,
      rating: ratingValue,
      review: reviewComment,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");
      rating.value = 0;
      reviewCommentController.clear();
      Get.back();
      Get.snackbar(
        "Success",
        "Your rating has been sent",
      );
    } else {
      print("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      Get.snackbar(
        "ERROR".tr,
        errorMessage,
      );
      update();
      // });
    }
  }

  reportService(
    String bookingId,
    String reportMessage,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().reportService(
      bookingId: bookingId,
      reportMessage: reportMessage,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      reportServiceController.clear();
      Get.back();
      Get.snackbar(
        "Success",
        "Your report has been sent",
      );
    } else {
      print("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      Get.snackbar(
        "ERROR".tr,
        errorMessage,
      );
      update();
      // });
    }
  }

  confirmBookingCompletion(
    String bookingId,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().confirmBookingCompletion(
      bookingId: bookingId,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");
      Get.snackbar("Success", "Thanks for your confirmation");

      Get.back();
      update();
    } else {
      print("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      Get.snackbar(
        "ERROR".tr,
        errorMessage,
      );

      update();
      // });
    }
  }

  cancelBookingRequest(
    String bookingId,
    String reason,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().cancelBookings(
      bookingId: bookingId,
      reason: reason,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      Get.back();
      update();
    } else {
      print("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);

      update();
      // });
    }
  }
}
