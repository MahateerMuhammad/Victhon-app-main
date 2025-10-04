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
    print("=== BANK FORM VALIDATION DEBUG ===");
    print("Account Number: '${accountNumberController.text}' (isEmpty: ${accountNumberController.text.isEmpty})");
    print("Account Name: '${accountNameController.text}' (isEmpty: ${accountNameController.text.isEmpty})");
    print("Selected Bank: $selectedBank (isEmpty: ${selectedBank.isEmpty})");
    print("Selected Bank Name: ${selectedBank.isNotEmpty ? selectedBank['bankName'] : 'No bank selected'}");
    
    isFormFilled.value = accountNumberController.text.isNotEmpty &&
        accountNameController.text.isNotEmpty &&
        selectedBank.isNotEmpty;
    
    print("Form is filled: ${isFormFilled.value}");
    print("=== END BANK FORM VALIDATION DEBUG ===");
  }

  @override
  void onInit() {
    print("🎯 CONTROLLER onInit() CALLED");
    super.onInit();
    fullNameController.addListener(updateCreateProfileFormFilled);
    businessNameController.addListener(updateCreateProfileFormFilled);
    ninController.addListener(updateCreateProfileFormFilled);

    print("🎯 About to call fetchAllBanks()");
    fetchAllBanks();
    print("🎯 fetchAllBanks() call completed");

    accountNumberController.addListener(updateBankAccountFormFilled);
    accountNameController.addListener(updateBankAccountFormFilled);
    ever(selectedBank, (_) => updateBankAccountFormFilled());
    print("🎯 Controller onInit() finished");
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
    print("🔐 About to create service provider profile");
    var currentToken = box.read('token');
    print("🔐 Current token before API call: '$currentToken'");
    
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
      // Map frontend userType to storage userType for navigation
      String storageUserType = userType == "provider" ? "serviceProvider" : userType;
      box.write("userType", storageUserType);
      debugPrint("💾 Provider profile stored userType: '$storageUserType' (from frontend userType: '$userType')");
      emailController.clear();
      phoneNumberController.clear();
      businessNameController.clear();
      ninController.clear();
      fullNameController.clear();
      country = '';
      state = '';
      isFormFilled.value = false;
      // Try bank ID first, if that fails we might need bank code
      addBankAccount(
        accountNameController.text,
        accountNumberController.text,
        selectedBank["_id"], // Use bank ID instead of name
        selectedBank["bankCode"], // Also pass bank code as fallback
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
    print("🚀 FETCHALLBANKS METHOD CALLED - START");
    print("=== FETCHING BANKS DEBUG ===");
    print("Starting to fetch bank details...");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedAccountDetails = prefs.getString("cached_bankDetails");
    if (savedAccountDetails != null) {
      print("Found cached bank details");
      bankDetails.value =
          List<dynamic>.from(json.decode(savedAccountDetails)).toList();
      print("Loaded ${bankDetails.length} banks from cache");
    } else {
      print("No cached bank details found");
    }

    // Fetch new services from API
    print("Fetching banks from API...");
    try {
      final response = await RemoteServices().getAllBanks();
      print("API Response: $response");
      print("Response Type: ${response.runtimeType}");
      print("Response toString: ${response.toString()}");

      if (response is ApiResponse) {
        print("Response is ApiResponse - Success: ${response.isSuccess}");
        if (response.isSuccess) {
          final data = response.data;
          print("API Success - Data: $data");
          print("Data type: ${data.runtimeType}");
          
          if (data is List) {
            // Direct array response
            bankDetails.value = data;
            print("Updated bankDetails with ${bankDetails.length} banks from API (direct array)");
          } else if (data is Map<String, dynamic> && data["data"] != null) {
            // Wrapped in data field
            bankDetails.value = data["data"];
            print("Updated bankDetails with ${bankDetails.length} banks from API (wrapped in data)");
          } else {
            print("Unexpected data format: $data");
          }
        } else {
          print("API Response failed: ${response.errorMessage}");
        }
      } else if (response is List) {
        // Direct array response from RemoteServices
        print("Direct array response from RemoteServices");
        bankDetails.value = response;
        print("Updated bankDetails with ${bankDetails.length} banks (direct)");
      } else if (response is Map<String, dynamic>) {
        print("Map response format");
        if (response["data"] != null) {
          bankDetails.value = response["data"];
          print("Updated bankDetails with ${bankDetails.length} banks (from map data)");
        } else {
          print("Map response without data field: $response");
        }
      } else {
        print("Unexpected response type: ${response.runtimeType}");
        print("Response content: $response");
      }
      
      if (bankDetails.isNotEmpty) {
        print("Final bankDetails count: ${bankDetails.length}");
        for (int i = 0; i < bankDetails.length && i < 3; i++) {
          print("Bank $i: ${bankDetails[i]}");
        }
        await prefs.setString("cached_bankDetails", json.encode(bankDetails));
        print("Saved bank details to cache");
      } else {
        print("No banks loaded - bankDetails is empty!");
      }
    } catch (e) {
      print("Error fetching banks: $e");
    }
    print("=== END FETCHING BANKS DEBUG ===");
  }

  // Simple test method to debug banks API
  void testBanksApi() async {
    print("🧪 TESTING BANKS API DIRECTLY");
    try {
      final response = await RemoteServices().getAllBanks();
      print("🧪 Direct API test response: $response");
      print("🧪 Response type: ${response.runtimeType}");
    } catch (e) {
      print("🧪 API test error: $e");
    }
  }

  addBankAccount(
    String accountName,
    String accountNumber,
    String bankId,
    String bankCode,
    bool isPrimaryAccount,
  ) async {
    print("=== ADD BANK ACCOUNT DEBUG ===");
    print("Account Name: '$accountName'");
    print("Account Number: '$accountNumber'");
    print("Bank ID: '$bankId'");
    print("Bank Code: '$bankCode'");
    print("Is Primary Account: $isPrimaryAccount");
    print("Selected Bank Details: $selectedBank");
    
    isLoading(true);
    final ApiResponse response = await RemoteServices().addBankAccount(
      accountName: accountName,
      accountNumber: accountNumber,
      bankId: bankId,
      bankCode: bankCode,
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
      print("Response Status Code: ${response.statusCode}");
      print("Response Error: ${response.errorMessage}");

      isLoading(false);
      
      // Handle authentication errors specifically
      String errorMessage;
      if (response.statusCode == 401 || response.statusCode == 403) {
        errorMessage = "Your session has expired. Please sign up again to continue.";
        // Optionally navigate back to login/signup
        // Get.offAllNamed('/signup');
      } else if (response.statusCode == 0) {
        errorMessage = "No internet connection. Please check your network and try again.";
      } else {
        errorMessage = response.errorMessage ?? "Failed to add bank account. Please try again.";
      }
      
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
      update();
    }
  }
}
