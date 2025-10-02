import 'dart:convert';
import 'dart:io';

import 'package:Victhon/app/service_provider/createProfile/views/add_bank_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Victhon/app/service_provider/bookings/widget/bookings_dailog.dart';
import 'package:Victhon/utils/icons.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../main.dart';
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
    ApiResponse response =
        await RemoteServices().uploadMedia(imageFile: imageFile);
    isLoading(false);
    if (response.isSuccess) {
      // ✅ Check if widget is still mounted before using BuildContext

      final dynamic responseData = jsonDecode(response.data);
      print("type ${responseData.runtimeType}");

      print("responseData $responseData");
      profileImageUrl.value = responseData["imageUrl"];
      print("profileImage Data: ${profileImageUrl.value}");

      Get.to(() => AddBankDetails());

      // }
    } else {
      print(response.errorMessage);
      print(response.statusCode);

      const errorMessage = "An error occurred, please try again";
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
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

    if (response is Map<String, dynamic>) {
      bankDetails.value = response["data"];
      await prefs.setString("cached_bankDetails", json.encode(response["data"]));
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
