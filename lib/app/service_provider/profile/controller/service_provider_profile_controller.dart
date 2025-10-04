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
    debugPrint("heyyyyyyyy fetch profileDetails");
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
    debugPrint("@@@@@@@@@@ $response @@@@@@@@@@");
    debugPrint("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

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

      debugPrint("Response Data: $responseData");

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
      debugPrint("--------- $response");

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
      debugPrint("Profile Image Response Data: $responseData");

      // Handle both possible response formats
      String? imageUrl;
      if (responseData is Map<String, dynamic>) {
        if (responseData["imageUrl"] != null) {
          imageUrl = responseData["imageUrl"];
        } else if (responseData["imageUrls"] != null &&
            responseData["imageUrls"] is List &&
            responseData["imageUrls"].isNotEmpty) {
          imageUrl = responseData["imageUrls"][0];
        }
      }

      if (imageUrl != null) {
        profileImageUrl.value = imageUrl;
        debugPrint("profileImage Data: ${profileImageUrl.value}");

        customSnackbar(
          "Success",
          "Profile image updated successfully",
          AppColor.greenColor,
        );
      }
    } else {
      debugPrint(response.errorMessage);
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

      debugPrint("Response Data: $responseData");
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
      debugPrint("--------- $response");

      isLoading(false);
      final errorMessage = response.errorMessage ?? "An error occurred";
      // Future.delayed(const Duration(milliseconds: 10), () {
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);

      update();
      // });
    }
  }

  Future<void> fetchNotifiPreference() async {
    debugPrint("heyyyyyyyy fetch NotifiPreference");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedNotifiPreference = prefs.getString("cached_notifiPreference");
    if (savedNotifiPreference != null) {
      try {
        final cachedData = Map<String, dynamic>.from(json.decode(savedNotifiPreference));
        notifiPreference.value = cachedData;
        
        // Use null-safe access with fallback to false for cached data
        bookingRequests.value = cachedData["bookingRequests"] as bool? ?? false;
        messages.value = cachedData["newMessages"] as bool? ?? cachedData["messages"] as bool? ?? false;
        payments.value = cachedData["paymentReceived"] as bool? ?? cachedData["payments"] as bool? ?? false;
        customerReviews.value = cachedData["customerReviews"] as bool? ?? false;
      } catch (e) {
        debugPrint("Error loading cached notification preferences: $e");
        // Set defaults if cached data is corrupted
        bookingRequests.value = false;
        messages.value = false;
        payments.value = false;
        customerReviews.value = false;
      }
    }

    // Fetch new services from API
    try {
      final response = await RemoteServices().getNotifiPreference();
      debugPrint("@@@@@@@@@@ ${response?["data"]} @@@@@@@@@@");
      debugPrint("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

      if (response is Map<String, dynamic> && response["data"] != null) {
      final data = response["data"] as Map<String, dynamic>;
      notifiPreference.value = data;
      
      // Use null-safe access with backend property names and default false values
      bookingRequests.value = data["bookingRequests"] as bool? ?? false;
      messages.value = data["newMessages"] as bool? ?? data["messages"] as bool? ?? false;
      payments.value = data["paymentReceived"] as bool? ?? data["payments"] as bool? ?? false;
      customerReviews.value = data["customerReviews"] as bool? ?? false;

        await prefs.setString("cached_notifiPreference", json.encode(data));
      } else {
        // Set default false values if no preferences found
        bookingRequests.value = false;
        messages.value = false;
        payments.value = false;
        customerReviews.value = false;
      }
    } catch (e) {
      debugPrint("Error fetching notification preferences: $e");
      // Set default false values on error (e.g., 403 Forbidden for customers)
      bookingRequests.value = false;
      messages.value = false;
      payments.value = false;
      customerReviews.value = false;
      // Re-throw the error so the UI can handle it
      rethrow;
    }
  }

  updateNotifiPreference({
    required bool bookingRequestsValue,
    required bool messagesValue,
    required bool paymentsValue,
    required bool customerReviewsValue,
  }) async {
    isLoading(true);
    
    // First check if preferences exist (getNotifiPreference returns null when no actual preferences exist)
    final getResponse = await RemoteServices().getNotifiPreference();
    
    // If preferences don't exist, create them first with false defaults
    if (getResponse == null) {
      debugPrint("Preferences not found, creating default false preferences...");
      final createResponse = await RemoteServices().createNotifiPreference();
      if (createResponse == null) {
        isLoading(false);
        debugPrint("Failed to create notification preferences");
        return;
      }
      debugPrint("Default false preferences created successfully");
    }
    
    // Now update the preferences
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
      debugPrint("responseData Data: $responseData");
      
      // Handle property name differences between frontend and backend
      bookingRequests.value = responseData["bookingRequests"] as bool? ?? false;
      messages.value = responseData["newMessages"] as bool? ?? responseData["messages"] as bool? ?? false;
      payments.value = responseData["paymentReceived"] as bool? ?? responseData["payments"] as bool? ?? false;
      customerReviews.value = responseData["customerReviews"] as bool? ?? false;

      // Get.snackbar(
      //   "Success",
      //   "Deleted successfully",
      // );
    } else {
      debugPrint(response.errorMessage);
      const errorMessage = "An error occurred";
      Get.snackbar(
        "ERROR".tr,
        errorMessage,
      );
    }
  }
}
