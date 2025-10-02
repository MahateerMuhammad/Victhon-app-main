import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../main.dart';
import '../../../../utils/icons.dart';
import '../../../../widget/custom_snackbar.dart';
import '../../../customerApp/auth/views/onboarding_screen.dart';
import '../../bookings/widget/bookings_dailog.dart';

class ServiceProviderProfileController extends GetxController {
  final isLoading = false.obs;
  var remainingTimerTime = 5.obs;
  Timer? timer;

  RxMap<String, dynamic> profileDetails =
      <String, dynamic>{}.obs; // Stores services
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  RxString profileImageUrl = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();

  RxMap<String, dynamic> notifiPreference = <String, dynamic>{}.obs;
  RxBool bookingRequests = false.obs;
  RxBool messages = false.obs;
  RxBool payments = false.obs;
  RxBool customerReviews = false.obs;
  RxBool emailNotifications = false.obs;
  RxBool smsNotifications = false.obs;

  String country = '';
  String state = '';

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchNotifiPreference();
  }

  signOut() async {
    isLoading(true);
    prefs = await SharedPreferences.getInstance();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimerTime > 0) {
        remainingTimerTime--;
      } else {
        isLoading(false);

        timer.cancel(); // Stop the timer
        box.write("authStatus", "loggedOut");
        box.write('token', '');
        prefs.clear();
        Get.offAll(() => const OnboardingScreen());
      }
    });
  }

  Future<void> fetchProfile() async {
    print("heyyyyyyyy fetch profileDetails");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedProfileDetails = prefs.getString("cached_profileDetails");
    if (savedProfileDetails != null) {
      profileDetails.value =
          Map<String, dynamic>.from(json.decode(savedProfileDetails));
      nameController.text = profileDetails["fullName"];
      emailController.text = profileDetails["email"];
      phoneNumberController.text = profileDetails["phone"];
      businessNameController.text = profileDetails["businessName"];

      profileImageUrl.value = profileDetails["imageUrl"];
    }

    // Fetch new services from API
    final response = await RemoteServices().getServiceProviderProfile();
    print("@@@@@@@@@@ ${response} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

    if (response is Map<String, dynamic>) {
      profileDetails.value = response["profile"];
      nameController.text = profileDetails["fullName"];
      emailController.text = profileDetails["email"];
      phoneNumberController.text = profileDetails["phone"];
      businessNameController.text = profileDetails["businessName"];
      profileImageUrl.value = profileDetails["imageUrl"];

      await prefs.setString(
          "cached_profileDetails", json.encode(response["profile"]));
    }
  }

  editProviderProfile(
    String fullName,
    String businessName,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().editServiceProviderProfile(
      fullName: fullName,
      businessName: businessName,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      // Get.back();
      profileDetails.value = responseData["profile"];
      nameController.text = responseData["profile"]["fullName"];
      emailController.text = responseData["profile"]["email"];
      phoneNumberController.text = responseData["profile"]["phone"];
      customSnackbar(
        "Success",
        "Profile updated successfully",
        AppColor.greenColor,
      );
    } else {
      print("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";

      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

  addProviderProfileImage({
    required File imageFile,
  }) async {
    isLoading(true);
    ApiResponse response = await RemoteServices()
        .addServiceProviderProfileImage(imageFile: imageFile);
    isLoading(false);
    if (response.isSuccess) {
      // ✅ Check if widget is still mounted before using BuildContext

      final dynamic responseData = jsonDecode(response.data);
      print("prfileIm Data: ${responseData["imageUrls"][0]}");

      profileImageUrl.value = responseData["imageUrls"][0];
      print("profileImage Data: ${profileImageUrl.value}");

      customSnackbar(
        "Success",
        "Profile image updated successfully",
        AppColor.greenColor,
      );

      // }
    } else {
      print(response.errorMessage);
      const errorMessage = "An error occurred";
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

  setTransactionPin(
    String pin,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().setWalletPin(
      pin: pin,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");
      Get.snackbar("Success", "Pin created successfully");
      if (context.mounted) {
        showStatusDialog(
          context,
          AppIcons.checkMarkBadge,
          "Pin Created Successfully",
          "Your transaction PIN has been set up. You'll need this PIN to authorize your withdrawals.",
          "Done",
        );
      }
      confirmPinController.clear();
      pinController.clear();

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

  Future<void> fetchNotifiPreference() async {
    print("heyyyyyyyy fetch NotifiPreference");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedNotifiPreference = prefs.getString("cached_notifiPreference");
    if (savedNotifiPreference != null) {
      notifiPreference.value =
          Map<String, dynamic>.from(json.decode(savedNotifiPreference));
      bookingRequests.value = notifiPreference["bookingRequests"];
      messages.value = notifiPreference["messages"];
      payments.value = notifiPreference["payments"];
      customerReviews.value = notifiPreference["customerReviews"];
    }

    // Fetch new services from API
    final response = await RemoteServices().getNotifiPreference();
    print("@@@@@@@@@@ ${response["data"]} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

    if (response is Map<String, dynamic>) {
      notifiPreference.value = response["data"];
      bookingRequests.value = notifiPreference["bookingRequests"];
      messages.value = notifiPreference["messages"];
      payments.value = notifiPreference["payments"];
      customerReviews.value = notifiPreference["customerReviews"];

      await prefs.setString(
          "cached_notifiPreference", json.encode(response["data"]));
    }
  }

  updateNotifiPreference({
    required bool bookingRequestsValue,
    required bool messagesValue,
    required bool paymentsValue,
    required bool customerReviewsValue,
  }) async {
    isLoading(true);
    ApiResponse response = await RemoteServices().updateNotifiPreference(
      bookingRequests: bookingRequestsValue,
      messages: messagesValue,
      payments: paymentsValue,
      customerReviews: customerReviewsValue,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Check if widget is still mounted before using BuildContext

      final dynamic responseData = response.data["data"];
      print("responseData Data: $responseData");
      bookingRequests.value = responseData["bookingRequests"];
      messages.value = responseData["messages"];
      payments.value = responseData["payments"];
      customerReviews.value = responseData["customerReviews"];

      // Get.snackbar(
      //   "Success",
      //   "Deleted successfully",
      // );
    } else {
      print(response.errorMessage);
      const errorMessage = "An error occurred";
      Get.snackbar(
        "ERROR".tr,
        errorMessage,
      );
    }
  }
}
