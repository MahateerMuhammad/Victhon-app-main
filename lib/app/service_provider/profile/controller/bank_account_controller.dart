import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../widget/custom_snackbar.dart';

class BankAccountController extends GetxController {
  final isLoading = false.obs;

  RxList<dynamic> accountDetails = <dynamic>[].obs;
  RxMap<String, dynamic> selectedBank = <String, dynamic>{}.obs;
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  RxString selectedBankId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccountDetails();
    // fetchAllBanks();
  }

  Future<void> fetchAccountDetails() async {
    debugPrint("heyyyyyyyy fetch accountDetails");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedAccountDetails = prefs.getString("cached_accountDetails");
    if (savedAccountDetails != null) {
      accountDetails.value =
          List<dynamic>.from(json.decode(savedAccountDetails)).toList();
    }

    // Fetch new services from API
    final response = await RemoteServices().getBankAccounts();
    debugPrint("@@@@@@@@@@ ${response["data"]} @@@@@@@@@@");
    debugPrint("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

    if (response is Map<String, dynamic>) {
      accountDetails.value = response["data"];
      await prefs.setString(
          "cached_accountDetails", json.encode(response["data"]));
    }
  }

  // Future<void> fetchAllBanks() async {
  //   debugPrint("heyyyyyyyy fetch accountDetails");
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // // Check if services exist in local storage
  //   // String? savedAccountDetails = prefs.getString("cached_accountDetails");
  //   // if (savedAccountDetails != null) {
  //   //   accountDetails.value =
  //   //       List<dynamic>.from(json.decode(savedAccountDetails)).toList();
  //   // }

  //   // Fetch new services from API
  //   final response = await RemoteServices().getAllBanks();
  //   debugPrint("@@@@@@@@@@ ${response} @@@@@@@@@@");
  //   debugPrint("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");

  //   if (response is List<dynamic>) {
  //     bankDetails.value = response;
  //     // await prefs.setString(
  //     //     "cached_accountDetails", json.encode(response["data"]));
  //   }
  // }

  addBankAccount(
    String accountName,
    String accountNumber,
    String bankId,
    String bankCode,
    bool isPrimaryAccount,
    BuildContext context,
  ) async {
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

      debugPrint("Response Data: $responseData");
      Get.snackbar(
        "Success".tr,
        "Bank Account Added",
      );
      Get.back();
      // Get.to(()=> )

      accountNameController.clear();
      accountNumberController.clear();
      selectedBank.value = {};

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

  deleteBankAccount(
    String bankAccountId,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().deleteBankAccount(
      bankAccountId: bankAccountId,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");
      Get.snackbar(
        "Success".tr,
        "Bank Account Added",
      );

      fetchAccountDetails();

      // Get.delete<BankAccountController>();
      // Get.put(BankAccountController());

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

  void goBackAndReloadController() {
    // Future.delayed(Duration(milliseconds: 300), () {
    Get.delete<BankAccountController>();
    Get.put(BankAccountController());
    // });
  }
}
