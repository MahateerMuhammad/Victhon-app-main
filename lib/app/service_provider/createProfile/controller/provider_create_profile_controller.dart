import 'dart:convert';
import 'dart:io';

import 'package:Victhon/app/service_provider/createProfile/views/add_bank_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../main.dart';
import '../../../../utils/api_list.dart';
import '../../../../widget/custom_snackbar.dart';
import '../../../customerApp/auth/views/welcome_message_screen.dart';

class ProviderCreateProfileController extends GetxController {
  final isLoading = false.obs;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final businessNameController = TextEditingController();
  final ninController = TextEditingController();
  String identifier = '';
  // var selectedCountry = "Nigeria".obs; // Observable variable
  // var selectedState = "Lagos".obs;
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  RxString profileImageUrl = ''.obs;

  RxList<dynamic> bankDetails = <dynamic>[].obs;
  RxMap<String, dynamic> selectedBank = <String, dynamic>{}.obs;

  final isFormFilled = false.obs;

  void updateCreateProfileFormFilled() {
    isFormFilled.value = fullNameController.text.isNotEmpty &&
        businessNameController.text.isNotEmpty &&
        ninController.text.isNotEmpty;
  }

  void updateBankAccountFormFilled() {
    isFormFilled.value = accountNumberController.text.isNotEmpty &&
        accountNameController.text.isNotEmpty &&
        selectedBank.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    fullNameController.addListener(updateCreateProfileFormFilled);
    businessNameController.addListener(updateCreateProfileFormFilled);
    ninController.addListener(updateCreateProfileFormFilled);

    fetchAllBanks();

    accountNumberController.addListener(updateBankAccountFormFilled);
    accountNameController.addListener(updateBankAccountFormFilled);
    ever(selectedBank, (_) => updateBankAccountFormFilled());
  }

  createServiceProviderProfile(
    String fullName,
    String email,
    String phoneNumber,
    String businessName,
    String country,
    String state,
    String nin,
    String userType,
    String profileImage,
  ) async {
    isLoading(true);
    final ApiResponse response =
        await RemoteServices().createServiceProviderProfile(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      businessName: businessName,
      country: country,
      state: state,
      nin: nin,
      imageUrl: profileImage,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");
      box.write("userType", userType);
      emailController.clear();
      phoneNumberController.clear();
      businessNameController.clear();
      ninController.clear();
      fullNameController.clear();
      country = '';
      state = '';
      isFormFilled.value = false;
      addBankAccount(
        accountNameController.text,
        accountNumberController.text,
        selectedBank["name"],
        true,
      );

      update();
    } else {
      // ❌ Extracting error message from response
      // Get.back();
      final errorMessage =
          response.errorMessage ?? "An error occurred, please try again";

      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

  addProviderProfileImage({
    required File imageFile,
    required BuildContext context,
  }) async {
    isLoading(true);

    try {
      // Validate file before upload
      if (!await imageFile.exists()) {
        isLoading(false);
        customSnackbar(
            "ERROR".tr, "Selected image file not found", AppColor.error);
        return;
      }

      // Check file size (limit to 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        isLoading(false);
        customSnackbar(
            "ERROR".tr,
            "Image file is too large. Please select an image smaller than 5MB",
            AppColor.error);
        return;
      }

      print("Uploading image: ${imageFile.path}");
      print("File size: ${fileSize} bytes");
      print("Using endpoint: ${ApiList.profileImage}provider");

      ApiResponse response = await RemoteServices()
          .addServiceProviderProfileImage(imageFile: imageFile);
      isLoading(false);

      if (response.isSuccess) {
        try {
          final dynamic responseData = jsonDecode(response.data);
          print("Upload response type: ${responseData.runtimeType}");
          print("Upload response data: $responseData");

          // Handle both possible response formats
          String? imageUrl;
          if (responseData is Map<String, dynamic>) {
            if (responseData["imageUrl"] != null) {
              // Single image URL format
              imageUrl = responseData["imageUrl"];
            } else if (responseData["imageUrls"] != null &&
                responseData["imageUrls"] is List &&
                responseData["imageUrls"].isNotEmpty) {
              // Array of image URLs format
              imageUrl = responseData["imageUrls"][0];
            }
          }

          if (imageUrl != null && imageUrl.isNotEmpty) {
            profileImageUrl.value = imageUrl;
            print("Profile image URL: ${profileImageUrl.value}");

            // Navigate to next screen
            Get.to(() => AddBankDetails());
          } else {
            print("No image URL found in response: $responseData");
            customSnackbar("ERROR".tr,
                "Invalid response from server - no image URL", AppColor.error);
          }
        } catch (e) {
          print("Error parsing upload response: $e");
          customSnackbar(
              "ERROR".tr, "Failed to process server response", AppColor.error);
        }
      } else {
        print("Upload failed - Status: ${response.statusCode}");
        print("Upload failed - Error: ${response.errorMessage}");

        // Provide more specific error messages
        String errorMessage = response.errorMessage ?? "Upload failed";

        if (response.statusCode == 0) {
          errorMessage =
              "No internet connection. Please check your network and try again";
        } else if (response.statusCode == 413) {
          errorMessage = "Image file is too large";
        } else if (response.statusCode == 415) {
          errorMessage = "Unsupported image format";
        } else if (response.statusCode == 401) {
          errorMessage = "Authentication failed. Please login again";
        } else if (response.statusCode == 404) {
          errorMessage =
              "Profile not found. Please complete your profile first";
        } else if (response.statusCode == 400) {
          errorMessage = "Invalid request. Please try again";
        } else if (response.statusCode == 500) {
          errorMessage = "Server error. Please try again later";
        }

        customSnackbar("ERROR".tr, errorMessage, AppColor.error);
      }
    } catch (e) {
      isLoading(false);
      print("Unexpected error during image upload: $e");
      customSnackbar(
          "ERROR".tr, "An unexpected error occurred: $e", AppColor.error);
    }
  }

  Future<void> fetchAllBanks() async {
    print("heyyyyyyyy fetch accountDetails");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedAccountDetails = prefs.getString("cached_bankDetails");
    if (savedAccountDetails != null) {
      bankDetails.value =
          List<dynamic>.from(json.decode(savedAccountDetails)).toList();
    }

    // Fetch new services from API
    final response = await RemoteServices().getAllBanks();
    print("@@@@@@@@@@ ${response} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

    if (response is ApiResponse && response.isSuccess) {
      final data = response.data;
      if (data is Map<String, dynamic> && data["data"] != null) {
        bankDetails.value = data["data"];
        await prefs.setString(
            "cached_bankDetails", json.encode(data["data"]));
      }
    } else if (response is Map<String, dynamic>) {
      bankDetails.value = response["data"];
      await prefs.setString(
          "cached_bankDetails", json.encode(response["data"]));
    }
  }

  addBankAccount(
    String accountName,
    String accountNumber,
    String bankName,
    bool isPrimaryAccount,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().addBankAccount(
      accountName: accountName,
      accountNumber: accountNumber,
      bankName: bankName,
      isPrimaryAccount: isPrimaryAccount,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");

      accountNameController.clear();
      accountNumberController.clear();
      // fullNameController.clear();
      isFormFilled.value = false;

      selectedBank.value = {};
      box.write("authStatus", "loggedIn");

      Get.to(() => WelcomeMessageScreen(
            userType: box.read("userType"),
            userName: fullNameController.text,
          ));

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
