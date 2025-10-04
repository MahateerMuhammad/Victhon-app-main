import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/views/create_profile_screen.dart';
import 'package:Victhon/app/customerApp/auth/views/otp_screen.dart';
import 'package:Victhon/app/customerApp/auth/views/reset_password_screen.dart';
import 'package:Victhon/app/customerApp/auth/views/welcome_message_screen.dart';
import 'package:Victhon/app/customerApp/bottonNavBar/view/bottom_nav_bar.dart';
import 'package:Victhon/app/service_provider/createProfile/views/create_profile.dart';
import 'package:Victhon/app/service_provider/bottomNavBar/view/service_provider_bottom_nav_bar.dart';
import 'package:Victhon/main.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../utils/constants.dart';
import '../../../../widget/custom_snackbar.dart';
import '../views/onboarding_screen.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final passwordObscure = true.obs;

  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  // auth_controller.dart
  RxBool hasUppercase = false.obs;
  RxBool hasLowercase = false.obs;
  RxBool hasNumber = false.obs;
  RxBool hasSpecialChar = false.obs;
  RxBool hasMinLength = false.obs;

  final isFormFilled = false.obs;

  void updateSignupFormFilled() {
    isFormFilled.value = identifierController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void updateCreateProfileFormFilled() {
    isFormFilled.value = fullNameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    identifierController.addListener(updateSignupFormFilled);
    passwordController.addListener(updateSignupFormFilled);
    pinController.addListener(() {
      isFormFilled.value = true;
    });
    fullNameController.addListener(updateCreateProfileFormFilled);
    phoneNumberController.addListener(updateCreateProfileFormFilled);
  }

  final confirmPasswordController = TextEditingController();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final pinController = TextEditingController();

  void validatePassword(String password) {
    hasUppercase.value = password.contains(RegExp(r'[A-Z]'));
    hasLowercase.value = password.contains(RegExp(r'[a-z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));
    hasSpecialChar.value =
        password.contains(RegExp(r'[!@#\$&*~%^(),.?":{}|<>]'));
    hasMinLength.value = password.length >= 6;
  }

  String? validatePasswordStrength(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain an uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain a lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain a number';
    }
    if (!RegExp(r'[!@#\$&*~%^(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain a special character';
    }

    return null; // ✅ Valid password
  }

  bool containsUppercase(String text) {
    final RegExp uppercaseRegex = RegExp(r'[A-Z]');
    return uppercaseRegex.hasMatch(text); // Returns true if uppercase exists
  }

  var remainingTime = 60.obs; // 60 seconds countdown
  var remainingTimerTime = 5.obs;
  Timer? timer;
  var hasOtpExpired = false.obs;

  var selectedCountry = "Nigeria".obs; // Observable variable
  var selectedState = "Abia".obs; // Observable variable
  var selectedCity = "Aba".obs; // Observable variable

  RxList<String> stateDropDownItem = nigeriaStateCitiesList
      .map<String>((item) => item["state"] as String)
      .toList()
      .obs;

  RxList<String> citiesDropDownItem =
      List<String>.from(nigeriaStateCitiesList[0]["cities"] as List).obs;

  void passwordObscureFunction() {
    passwordObscure.value = !passwordObscure.value;
  }

  void updateSelectedCountry(String value) {
    selectedCountry.value = value;
  }

  void updateSelectedState(String value) {
    selectedState.value = value;
  }

  void updateSelectedCity(String value) {
    selectedCity.value = value;
  }

  void startCountdown() {
    remainingTime.value = 60;
    hasOtpExpired.value = false;

    timer?.cancel(); // Cancel previous timer if exists
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        timer.cancel();
        hasOtpExpired.value = true;
      }
    });
  }

  void startTimer(String userType) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimerTime > 0) {
        remainingTimerTime--;
      } else {
        timer.cancel(); // Stop the timer
        if (userType == "customer") {
          Get.offAll(() => const CustomerBottomNavBar());
        } else {
          Get.offAll(() => const ServiceProviderBottomNavBar());
        }
      }
    });
  }

  signUp(
    String identifier,
    String password,
    String userType,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().signUp(
      identifier: identifier,
      password: password,
      userType: userType,
    );
    isLoading(false);

    if (response.isSuccess) {
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");

      isLoading(false);
      isFormFilled.value = false;
      Get.off(() => OtpScreen(
            signupOption:
                identifierController.text.isEmail ? "Email" : "Phone number",
            emailOrPhonenumber: identifierController.text,
            userType: userType,
            otpVerificationType: "signUp",
          ));
      update();
      customSnackbar("SUCCESS".tr, 'OTP sent successfully!'.toString().tr,
          AppColor.success);
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

  signIn(
    String identifier,
    String password,
    String userType,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().signIn(
      identifier: identifier,
      password: password,
      userType: userType,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");
      box.write('token', responseData["access_token"]);

      isLoading(false);
      isFormFilled.value = false;

      box.write("authStatus", "loggedIn");
      // Map frontend userType to storage userType for navigation
      String storageUserType = userType == "provider" ? "serviceProvider" : userType;
      box.write("userType", storageUserType);
      debugPrint("💾 Stored userType: '$storageUserType' (from frontend userType: '$userType')");
      identifierController.clear();
      passwordController.clear();
      if (userType == "customer") {
        Get.offAll(() => const CustomerBottomNavBar());
      } else {
        Get.offAll(() => const ServiceProviderBottomNavBar());
      }

      update();
      passwordController.clear();
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

  validateUserSignUp(
    String identifier,
    String otp,
    String userType,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().validateUserSignUp(
      identifier: identifier,
      otp: otp,
      userType: userType,
    );
    debugPrint("Response --- Data: ${response.data}");

    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");
      debugPrint("🔐 Response type: ${responseData.runtimeType}");
      debugPrint("🔐 Available keys: ${responseData is Map ? responseData.keys : 'N/A'}");
      
      // Try different possible token field names
      var accessToken = responseData["access_token"] ?? 
                       responseData["token"] ?? 
                       responseData["accessToken"] ?? 
                       responseData["authToken"];
      
      debugPrint("🔐 Access token from response: '$accessToken'");
      
      if (accessToken != null && accessToken.toString().isNotEmpty) {
        debugPrint("🔐 Saving token to storage");
        box.write('token', accessToken);
        
        // Verify token was saved
        var savedToken = box.read('token');
        debugPrint("🔐 Token after saving: '$savedToken'");
        debugPrint("🔐 Token verification: ${savedToken == accessToken}");
      } else {
        debugPrint("❌ No valid token found in response!");
        debugPrint("🔐 Checking individual fields:");
        debugPrint("  - access_token: '${responseData["access_token"]}'");
        debugPrint("  - token: '${responseData["token"]}'");
        debugPrint("  - accessToken: '${responseData["accessToken"]}'");
        debugPrint("  - authToken: '${responseData["authToken"]}'");
      }
      
      pinController.clear();
      identifierController.clear();
      fullNameController.clear();
      emailController.clear();
      passwordController.clear();
      isFormFilled.value = false;

      // Handling the response based on the data structure
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        customSnackbar(
          "SUCCESS".tr,
          "${responseData['message'].toString()} Please try again",
          AppColor.success,
        );
      } else {
        customSnackbar(
            "SUCCESS".tr, "OTP verification successful!", AppColor.success);
        if (userType == "customer") {
          Get.off(() => CreateProfileScreen(identifier: identifier));
        } else {
          Get.off(() => ProviderCreateProfileScreen(identifier: identifier));
        }
      }
    } else {
      // ❌ Extracting error message from response
      Get.back();
      final errorMessage = response.errorMessage ?? "An error occurred";

      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

  forgotPassword(
    String identifier,
    String userType,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().forgotPassword(
      identifier: identifier,
    );
    isLoading(false);
    debugPrint("Response Data: $response");
    debugPrint("Response Data: ${response.isSuccess}");

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");
      identifierController.clear();
      isFormFilled.value = false;

      customSnackbar("SUCCESS".tr, 'OTP sent successfully!'.toString().tr,
          AppColor.success);
      Get.off(() => OtpScreen(
            signupOption: identifier.isEmail ? "Email" : "Phone number",
            emailOrPhonenumber: identifier,
            userType: userType,
            otpVerificationType: "resetPassword",
          ));

      update();
      passwordController.clear();
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

  verifyOtp(
    String identifier,
    String otp,
    String userType,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().verifyOtp(
      identifier: identifier,
      otp: otp,
    );

    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");

      // Handling the response based on the data structure
      isFormFilled.value = false;

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        customSnackbar(
            "SUCCESS".tr, responseData['message'].toString(), AppColor.success);
      } else {
        customSnackbar(
            "SUCCESS".tr, "OTP verification successful!", AppColor.success);
      }

      Get.off(() => ResetPasswordScreen(
            emailOrPhonenumber: identifier,
          ));
    } else {
      // ❌ Extracting error message from response
      final errorMessage = response.errorMessage ?? "An error occurred";

      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

  resetPassword(
      String identifier, String password, String confirmPassword) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().resetPassword(
      identifier: identifier,
      password: password,
      confirmPassword: confirmPassword,
    );
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");
      box.write('token', responseData["access_token"]);

      customSnackbar(
          "SUCCESS".tr, "Password Reset successfully", AppColor.success);

      Get.offAll(() => const OnboardingScreen());

      passwordController.clear();
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

  createCustomerProfile(
    String fullName,
    String email,
    String phoneNumber,
    String country,
    String state,
    String userType,
  ) async {
    isLoading(true);
    final ApiResponse response = await RemoteServices().createCustomerProfile(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      country: country,
      state: state,
      userType: userType,
    );

    isLoading(false);

    if (response.isSuccess) {
      // ✅ Extracting data from the response
      final dynamic responseData = response.data;

      debugPrint("Response Data: $responseData");
      update();
      identifierController.clear();
      isFormFilled.value = false;

      // Handling the response based on the data structure
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        Get.back();
        customSnackbar(
            "SUCCESS".tr,
            "${responseData['message'].toString()} Please try again",
            AppColor.success);
      } else {
        box.write("authStatus", "loggedIn");
        // Map frontend userType to storage userType for navigation
        String storageUserType = userType == "provider" ? "serviceProvider" : userType;
        box.write("userType", storageUserType);
        debugPrint("💾 Google Sign-in stored userType: '$storageUserType' (from frontend userType: '$userType')");
        Get.off(() => WelcomeMessageScreen(
              userType: userType,  // Keep original userType for UI display
              userName: fullName,
            ));
      }
    } else {
      // ❌ Extracting error message from response
      Get.back();
      final errorMessage = response.errorMessage ?? "An error occurred";

      customSnackbar("ERROR".tr, errorMessage, AppColor.error);
    }
  }

  @override
  void onClose() {
    timer?.cancel(); // Cancel timer to avoid memory leaks
    super.onClose();
  }
}
