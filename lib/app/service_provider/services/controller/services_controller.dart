import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Victhon/data/server/app_server.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../main.dart';
import '../../../../widget/custom_snackbar.dart';
import '../widget/add_service_dialog.dart';

class ServicesController extends GetxController {
  final isLoading = false.obs;
  RxList<dynamic> categories = <dynamic>[].obs; 
  RxList<dynamic> providerServices = <dynamic>[].obs; 

  final serviceNameController = TextEditingController();
  RxString serviceCategory = ''.obs;
  RxString serviceCategoryId = ''.obs;

  final serviceDescriptionController = TextEditingController();
  RxInt servicePriceAmount = 0.obs;
  RxInt hourlyRateAmount = 0.obs;
  final isFlexiblePricing = true.obs;
  final isCustomPackage = false.obs;
  RxString pricingType = "Hourly Rate".obs;

  final remoteService = false.obs;
  final onsiteService = false.obs;
  final inStoreService = false.obs;
  final streetNumNameController = TextEditingController();
  final cityController = TextEditingController(); 

  final postalCodeController = TextEditingController();

  final String country = "Nigeria";

  List<String> serviceLocation = [];
  Map<String, dynamic> serviceAddress = {
    "street": "Remote Service",
    "city": "Remote Service",
    "state": "Remote Service", 
    "country": "Remote Service"
  };

  RxList<File?> serviceImages = <File?>[].obs;

  final isFormFilled = false.obs;

  updateServiceDetailsFormField() {
    isFormFilled.value = serviceNameController.text.isNotEmpty &&
        serviceDescriptionController.text.isNotEmpty &&
        serviceCategoryId.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllCategories();
    fetchProviderServices();
    serviceNameController.addListener(updateServiceDetailsFormField);
    serviceDescriptionController.addListener(updateServiceDetailsFormField);
    ever(serviceCategoryId, (_) => updateServiceDetailsFormField());

    // fetchCountryState();
  }

  Future<void> fetchAllCategories() async {
    // print("heyyyyyyyy fetch Categories");
   prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedCategories = prefs.getString("cached_categories_list");
    if (savedCategories != null) {
      categories.value = List<dynamic>.from(json.decode(savedCategories)).toList();
      serviceCategory.value = categories[0]["categoryName"];
      serviceCategoryId.value = categories[0]["_id"];
    }

    // Fetch new services from API
    final response = await RemoteServices().getAllCategories();
    print("###### ${response} ######");

    if (response is List) {
      categories.value = response;
      serviceCategory.value = response[0]["categoryName"];
      serviceCategoryId.value = response[0]["_id"];
      await prefs.setString("cached_categories_list", json.encode(response));
    }
  }

    Future<void> fetchProviderServices() async {
    print("heyyyyyyyy fetch provider Services");
    prefs = await SharedPreferences.getInstance();

    // Check if services exist in local storage
    String? savedProviderServices = prefs.getString("cached_provider_services");
    if (savedProviderServices != null) {
      providerServices.value = List<dynamic>.from(json.decode(savedProviderServices)).toList();
    }

    // Fetch new services from API
    final response = await RemoteServices().getProvderServices();
    print("###### $response ######");

    if (response is Map<String, dynamic>) {
      providerServices.value = response["data"];
      await prefs.setString("cached_provider_services", json.encode(response["data"]));
    }
  }

  createServices({
    required List<File?>? images,
    required String serviceName,
    required String serviceCategory,
    required String serviceDescription,
    required int servicePrice,
    required int hourlyRate,
    required bool isFlexiblePricing,
    required bool isCustomPackage,
    required List<String> serviceLocation,
    required Map<String, dynamic> serviceAddress,
    required BuildContext context,
  }) async {
    isLoading(true);
    ApiResponse response = await RemoteServices().createServices(
      images: images,
      serviceName: serviceName,
      serviceCategory: serviceCategory,
      serviceDescription: serviceDescription,
      servicePrice: servicePrice,
      hourlyRate: hourlyRate,
      isFlexiblePricing: isFlexiblePricing,
      isCustomPackage: isCustomPackage,
      serviceLocation: serviceLocation,
      serviceAddress: serviceAddress,
    );
    isLoading(false);
    if (response.isSuccess) {
      // if (Get.isDialogOpen == null) {
      // ✅ Check if widget is still mounted before using BuildContext
      if (context.mounted) {
        final dynamic responseData = response.data;
        print("Response Data: $responseData");
        serviceImages.clear();
        serviceNameController.clear();
        this.serviceCategory.value = '';
        serviceCategoryId.value = '';
        serviceDescriptionController.clear();
        servicePriceAmount.value = 0;
        hourlyRateAmount.value = 0;

        showSuccessfulDialog(context);
        update();
      }
      // }
    } else {
      print(response.errorMessage);
      const errorMessage = "An error occurred";
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

    updateServices({
    required List<File?>? images,
    required String serviceName,
    required String serviceCategory,
    required String serviceDescription,
    required int servicePrice,
    required int hourlyRate,
    required bool isFlexiblePricing,
    required bool isCustomPackage,
    required List<String> serviceLocation,
    required Map<String, dynamic> serviceAddress,
    required BuildContext context,
  }) async {
    isLoading(true);
    ApiResponse response = await RemoteServices().updateServices(
      images: images,
      serviceName: serviceName,
      serviceCategory: serviceCategory,
      serviceDescription: serviceDescription,
      servicePrice: servicePrice,
      hourlyRate: hourlyRate,
      isFlexiblePricing: isFlexiblePricing,
      isCustomPackage: isCustomPackage,
      serviceLocation: serviceLocation,
      serviceAddress: serviceAddress,
    );
    isLoading(false);
    if (response.isSuccess) {
      // if (Get.isDialogOpen == null) {
      // ✅ Check if widget is still mounted before using BuildContext
      if (context.mounted) {
        final dynamic responseData = response.data;
        print("Response Data: $responseData");
        serviceImages.clear();
        serviceNameController.clear();
        this.serviceCategory.value = '';
        serviceCategoryId.value = '';
        serviceDescriptionController.clear();
        servicePriceAmount.value = 0;
        hourlyRateAmount.value = 0;

        showSuccessfulDialog(context);
        update();
      }
      // }
    } else {
      print(response.errorMessage);
      const errorMessage = "An error occurred";
      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

    deleteService(
    String serviceId,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().deleteService(
      serviceId: serviceId,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      print("Response Data: $responseData");
      Get.snackbar(
        "Success".tr,
        "Service deleted successfully",
      );
      fetchProviderServices();

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
