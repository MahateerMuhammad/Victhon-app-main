import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Victhon/app/service_provider/bookings/widget/bookings_dailog.dart';
import 'package:Victhon/utils/icons.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../widget/custom_snackbar.dart';

class BookingsController extends GetxController {
  final isLoading = false.obs;
  var remainingTimerTime = 5.obs;
  Timer? timer;
  String bookingStatus = '';

  RxList<dynamic> bookings = <dynamic>[].obs; // Stores services
  RxList<dynamic> pendingBookings = <dynamic>[].obs;
  RxList<dynamic> upcomingBookings = <dynamic>[].obs;
  RxList<dynamic> ongoingBookings = <dynamic>[].obs;
  RxList<dynamic> completedBookings = <dynamic>[].obs;
  RxList<dynamic> declinedBookings = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    isLoading(true);
    print("heyyyyyyyy fetch fetchBookingsDetails");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedBookingsDetails = prefs.getString("cached_bookings");
    if (savedBookingsDetails != null) {
      bookings.value =
          List<dynamic>.from(json.decode(savedBookingsDetails)).toList();
    }

    // Fetch all bookings
    final allBookingsRespnse = await RemoteServices()
        .getBookings(userType: "provider", bookingStatus: '');
    print("Allbookings $allBookingsRespnse @@@@@@@@@@");
    print("@@@@@@@@@@ ${allBookingsRespnse.runtimeType} @@@@@@@@@@");

    if (allBookingsRespnse is Map<String, dynamic>) {
      bookings.value = allBookingsRespnse["bookings"];
      await prefs.setString("cached_bookings", json.encode(allBookingsRespnse["bookings"]));
    }
    isLoading(false);


    //Fetch pending bookings
    final pendingBookingsResponse = await RemoteServices()
        .getBookings(userType: "provider", bookingStatus: '?status=Pending');
    print("Pending $pendingBookingsResponse @@@@@@@@@@");
    print("@@@@@@@@@@ ${pendingBookingsResponse.runtimeType} @@@@@@@@@@");

    if (pendingBookingsResponse is Map<String, dynamic>) {
      pendingBookings.value = pendingBookingsResponse["bookings"];
      // await prefs.setString("cached_bookings", json.encode(response["profile"]));
    }

    //Fetch upcoming bookings
    final upcomingBookingsResponse = await RemoteServices()
        .getBookings(userType: "provider", bookingStatus: '?status=Upcoming');
    print("upcoming $upcomingBookingsResponse @@@@@@@@@@");
    print("@@@@@@@@@@ ${upcomingBookingsResponse.runtimeType} @@@@@@@@@@");

    if (upcomingBookingsResponse is Map<String, dynamic>) {
      upcomingBookings.value = upcomingBookingsResponse["bookings"];
      // await prefs.setString("cached_bookings", json.encode(response["profile"]));
    }

    //Fetch ongoing bookings
    final ongoingBookingsResponse = await RemoteServices()
        .getBookings(userType: "provider", bookingStatus: '?status=Ongoing');
    print("ongoing $ongoingBookingsResponse @@@@@@@@@@");
    print("@@@@@@@@@@ ${ongoingBookingsResponse.runtimeType} @@@@@@@@@@");

    if (ongoingBookingsResponse is Map<String, dynamic>) {
      ongoingBookings.value = ongoingBookingsResponse["bookings"];
      // await prefs.setString("cached_bookings", json.encode(response["profile"]));
    }

    //Fetch completed bookings
    final completedBookingsResponse = await RemoteServices()
        .getBookings(userType: "provider", bookingStatus: '?status=Completed');
    print("completed $completedBookingsResponse @@@@@@@@@@");
    print("@@@@@@@@@@ ${completedBookingsResponse.runtimeType} @@@@@@@@@@");

    if (completedBookingsResponse is Map<String, dynamic>) {
      completedBookings.value = completedBookingsResponse["bookings"];
      // await prefs.setString("cached_bookings", json.encode(response["profile"]));
    }

    //Fetch declined bookings
    final declinedBookingsResponse = await RemoteServices()
        .getBookings(userType: "provider", bookingStatus: '?status=Declined');
    print("cancelled $declinedBookingsResponse @@@@@@@@@@");
    print("@@@@@@@@@@ ${declinedBookingsResponse.runtimeType} @@@@@@@@@@");

    if (declinedBookingsResponse is Map<String, dynamic>) {
      declinedBookings.value = declinedBookingsResponse["bookings"];
      // await prefs.setString("cached_bookings", json.encode(response["profile"]));
    }
  }

  acceptBookings(
    String bookingId,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().acceptBookings(bookingId: bookingId);
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      if (context.mounted) {
        showStatusDialog(
          context,
          AppIcons.checkMarkBadge,
          "Booking Accepted Successfully",
          "You have successfully accepted this booking. The customer has been notified, and the booking details are now confirmed",
          "View Booking Details",
        );
      }
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

  startBookings(
    String bookingId,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().startBookings(bookingId: bookingId);
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      if (context.mounted) {
        showStatusDialog(
          context,
          AppIcons.digitalClock,
          "Service Started",
          "You have successfully started this service. The customer has been notified.",
          "Done",
        );
      }
      update();
    } else {
      print("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);

      // showStatusDialog(context, statusImage, headerText, subText, buttonText)
      update();
      // });
    }
  }

  completeBookings(
    String bookingId,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().completeBookings(bookingId: bookingId);
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      if (context.mounted) {
        showStatusDialog(
          context,
          AppIcons.medal,
          "Service Completed",
          "The service has been successfully completed. The customer has been notified, and the task is now marked as finished.",
          "Done",
        );
      }
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

  declineBookings(
    String bookingId,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().declineBookings(bookingId: bookingId);
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      if (context.mounted) {
        // showStatusDialog(context, statusImage, headerText, subText, buttonText)
      }
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
