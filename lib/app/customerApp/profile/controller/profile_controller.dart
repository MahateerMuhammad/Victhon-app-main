import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Victhon/utils/constants.dart';
import 'dart:convert';
import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../main.dart';
import '../../../../widget/custom_snackbar.dart';
import '../../auth/views/onboarding_screen.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  var remainingTimerTime = 5.obs;
  Timer? timer;

  RxMap<String, dynamic> profileDetails =
      <String, dynamic>{}.obs; // Stores services
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  RxString profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  signOut() {
    isLoading(true);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimerTime > 0) {
        remainingTimerTime--;
      } else {
        isLoading(false);

        timer.cancel(); // Stop the timer

        box.write("authStatus", "loggedOut");
        box.write('token', '');
        Get.offAll(() => const OnboardingScreen());
      }
    });
  }

  Future<void> fetchProfile() async {
    print("heyyyyyyyy fetch profile");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedProfileDetails = prefs.getString("cached_profile");
    if (savedProfileDetails != null) {
      profileDetails.value =
          Map<String, dynamic>.from(json.decode(savedProfileDetails));
      nameController.text = profileDetails["fullName"];
      emailController.text = profileDetails["email"];
      phoneNumberController.text = profileDetails["phone"];
      profileImageUrl.value = profileDetails["imageUrl"];
      country.value = profileDetails["country"];
      state.value = profileDetails["state"];
    }

    // Fetch new services from API
    final response = await RemoteServices().getCustomerProfile();
    print("@@@@@@@@@@ ${response["profile"]} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

    if (response is Map<String, dynamic>) {
      profileDetails.value = response["profile"];
      nameController.text = profileDetails["fullName"];
      emailController.text = profileDetails["email"];
      phoneNumberController.text = profileDetails["phone"];
      profileImageUrl.value = profileDetails["imageUrl"];
      country.value = profileDetails["country"];
      state.value = profileDetails["state"];

      await prefs.setString("cached_profile", json.encode(response["profile"]));
    }
  }

  editCustomerProfile(
    String fullName,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().editCustomerProfile(
      fullName: fullName,
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

  addCustomerProfileImage({
    required File imageFile,
  }) async {
    isLoading(true);
    ApiResponse response =
        await RemoteServices().addCustomerProfileImage(imageFile: imageFile);
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
}
