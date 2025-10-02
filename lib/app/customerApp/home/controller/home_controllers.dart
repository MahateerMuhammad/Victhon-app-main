import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Victhon/app/customerApp/home/widget/booking_status_bottom_sheet.dart';
import 'package:Victhon/main.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../utils/constants.dart';
import '../../../../widget/custom_snackbar.dart';

class HomeControllers extends GetxController {
  final isLoading = false.obs;
  final isRefreshLoading = false.obs;

  final searchController = TextEditingController().obs;
  final messageController = TextEditingController();

  RxString locationFilter = ''.obs;
  RxMap priceRangeFilter = {}.obs;
  RxString categoryFilter = ''.obs;

  RxList<dynamic> services = <dynamic>[].obs; // Stores services
  RxList<dynamic> searchServicesResult = <dynamic>[].obs;

  RxList<dynamic> categories = <dynamic>[].obs; // Stores services

  final List<String> searchFilterList = ["Location", "Price Range", "Category"];

  RxString serviceCategory = ''.obs;
  RxString serviceCategoryId = ''.obs;
  final isFormFilled = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchServices();
    fetchAllCategories();
    getStateList();
    messageController.addListener(() {
      isFormFilled.value = messageController.text.isNotEmpty;
    });
    box.write("Country", "Nigeria");
  }

  RxList<String> stateDropDownItem = <String>[].obs;

  getStateList() {
    if (box.read("Country") == "Nigeria") {
      stateDropDownItem.value = nigeriaStateCitiesList
          .map<String>((item) => item["state"] as String)
          .toList();

      print("------country-------- ${stateDropDownItem}");
    } else if (box.read("Country") == "Germany") {
      stateDropDownItem.value = germanyStatesCitiesList
          .map<String>((item) => item["state"] as String)
          .toList();

      print("-------country------- ${stateDropDownItem}");
    } else if (box.read("Country") == "Canada") {
      stateDropDownItem.value = canadaStateCitiesList
          .map<String>((item) => item["state"] as String)
          .toList();
    } else if (box.read("Country") == "United States") {
      stateDropDownItem.value = usStateCitiesList
          .map<String>((item) => item["state"] as String)
          .toList();
    } else if (box.read("Country") == "United Kingdom") {
      stateDropDownItem.value = ukStatesCitiesList
          .map<String>((item) => item["state"] as String)
          .toList();

      // }
      // You can add more conditions for other countries here
    }
  }

  Future<void> fetchServices() async {
    print("heyyyyyyyy fetch services");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedServices = prefs.getString("cached_services");
    if (savedServices != null) {
      services.value = List<dynamic>.from(json.decode(savedServices)).toList();
    }
    isLoading(true);
    // Fetch new services from API
    final response = await RemoteServices().getTopServices();
    print("@@@@@@@@@@ $response @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isLoading(false);

    if (response is Map<String, dynamic>) {
      services.value = response["data"];
      await prefs.setString("cached_services", json.encode(response["data"]));
    }
  }

  Future<void> refreshFetchServices() async {
    print("heyyyyyyyy fetch services");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isRefreshLoading(true);
    // Fetch new services from API
    final response = await RemoteServices().getTopServices();
    print("@@@@@@@@@@ $response @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isRefreshLoading(false);

    if (response is Map<String, dynamic>) {
      services.value = response["data"];
      await prefs.setString("cached_services", json.encode(response["data"]));
    }
  }

  Future<void> searchServices(
    String searchInput,
    String locationFilter,
    String priceRangeFilter,
    String categoryFilter,
  ) async {
    print("heyyyyyyyy fetch services");
    isLoading(true);

    // Fetch new services from API
    final response = await RemoteServices().searchServices(
        searchInput, locationFilter, priceRangeFilter, categoryFilter);
    isLoading(false);

    if (response is Map<String, dynamic>) {
      print("@@@@@@@@@@ ${response["services"]} @@@@@@@@@@");
      print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
      searchServicesResult.value = response["services"];
    } else {
      ApiResponse<dynamic> responseError = response;
      print("errorrrrrrrrrr !!!!!!!!");
      print("${responseError.data} errorrrrrrrrrr !!!!!!!!");
      print("${responseError.statusCode} errorrrrrrrrrr !!!!!!!!");
    }
  }

  Future<void> fetchAllCategories() async {
    print("heyyyyyyyy fetch Categories");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedStates = prefs.getString("cached_categories_list");
    if (savedStates != null) {
      categories.value = List<dynamic>.from(json.decode(savedStates)).toList();
      serviceCategory = categories[0]["categoryName"];
      serviceCategoryId = categories[0]["_id"];
    }

    // Fetch new services from API
    final response = await RemoteServices().getAllCategories();
    // print("###### ${response} ######");

    if (response is List) {
      categories.value = response;
      serviceCategory.value = response[0]["categoryName"];
      serviceCategoryId.value = response[0]["_id"];
      await prefs.setString("cached_categories_list", json.encode(response));
    }
  }

  bookService(
    String serviceId,
    String paymentMethod,
    String message,
    String street,
    String city,
    String state,
    String country,
    BuildContext context,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().bookService(
      serviceId: serviceId,
      paymentMethod: paymentMethod,
      message: message,
      street: street,
      city: city,
      state: state,
      country: country,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Bookings Data: $responseData");
      // Get.back();

      // WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          showBookingStatusDialog(context);
        }
      // });

      messageController.clear();

      // Get.to(() => const ServiceProviderBottomNavBar());

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
