import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../utils/api_list.dart';
import '../server/app_server.dart';

class RemoteServices {
  static Future<BaseOptions> getBasseOptions() async {
    BaseOptions options = BaseOptions(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: AppServer.getAuthHeaders());

    return options;
  }

  static Future<BaseOptions> getBasseOptionsWithToken() async {
    BaseOptions options = BaseOptions(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: AppServer.getHttpHeadersWithToken());

    return options;
  }

  AppServer server = AppServer();

  Future<dynamic> signUp({
    required String identifier,
    required String password,
    required String userType,
  }) async {
    final response = await server.postRequest(
        endPoint: ApiList.signUp + userType,
        headers: AppServer.getAuthHeaders(),
        body: {
          "identifier": identifier,
          "password": password,
        });

    return response;
  }

  Future<dynamic> signIn({
    required String identifier,
    required String password,
    required String userType,
  }) async {
    final response = await server.postRequest(
        endPoint: ApiList.signIn + userType,
        headers: AppServer.getAuthHeaders(),
        body: {
          "identifier": identifier,
          "password": password,
        });

    return response;
  }

  Future<dynamic> googleSignUp({
    required String idToken,
    required String userType,
  }) async {
    // Use mobile-specific endpoints for Flutter app
    String endpoint = userType == "customer"
        ? ApiList.customerGoogleAuth
        : ApiList.serviceProviderGoogleAuth;

    debugPrint('[DEBUG] GoogleSignUp - userType: $userType');
    debugPrint('[DEBUG] GoogleSignUp - endpoint: $endpoint');
    debugPrint('[DEBUG] GoogleSignUp - idToken length: ${idToken.length}');
    debugPrint(
        '[DEBUG] GoogleSignUp - idToken preview: ${idToken.substring(0, 50)}...');

    final response = await server.postRequest(
        endPoint: endpoint,
        headers: AppServer.getAuthHeaders(),
        body: {"idToken": idToken});

    debugPrint(
        '[DEBUG] GoogleSignUp - Response Status: ${response.statusCode}');
    debugPrint(
        '[DEBUG] GoogleSignUp - Response Success: ${response.isSuccess}');
    debugPrint('[DEBUG] GoogleSignUp - Response Data: ${response.data}');
    debugPrint(
        '[DEBUG] GoogleSignUp - Response Error: ${response.errorMessage}');

    return response;
  }

  Future<dynamic> verifyOtp({
    required String identifier,
    required String otp,
  }) async {
    final response = await server.postRequest(
        endPoint: ApiList.verifyOtp,
        headers: AppServer.getAuthHeaders(),
        body: {
          "identifier": identifier,
          "otp": otp,
        });

    return response;
  }

  Future<dynamic> validateUserSignUp({
    required String identifier,
    required String otp,
    required String userType,
  }) async {
    final response = await server.postRequest(
        endPoint: ApiList.validateUserSignUp + userType,
        headers: AppServer.getAuthHeaders(),
        body: {
          "identifier": identifier,
          "otp": otp,
        });

    return response;
  }

  Future<dynamic> createCustomerProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String country,
    required String state,
    required String userType,
  }) async {
    final response = await server.postRequest(
        endPoint: ApiList.profile + userType,
        headers: AppServer.getHttpHeadersWithToken(),
        body: {
          "fullName": fullName,
          "email": email,
          "phone": phoneNumber,
          "country": country,
          "state": state,
        });

    return response;
  }

  Future<dynamic> editCustomerProfile({
    required String fullName,
    // required String email,
    // required String phoneNumber,
    // required String country,
    // required String state,
  }) async {
    final response = await server.putRequest(
        endPoint: "${ApiList.profile}customer",
        headers: AppServer.getHttpHeadersWithToken(),
        body: {
          "fullName": fullName,
          // "email": email,
          // "phone": phoneNumber,
          // "country": country,
          // "state": state,
        });

    return response;
  }

  Future<dynamic> addCustomerProfileImage({
    required File imageFile,
  }) async {
    final response = await server.multipartRequest(
      "${ApiList.profileImage}customer",
      imageFile,
    );

    return response;
  }

  Future<dynamic> createServiceProviderProfile({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String businessName,
    required String country,
    required String state,
    required String nin,
    required String imageUrl,
  }) async {
    final response = await server.postRequest(
        endPoint: "${ApiList.profile}provider",
        headers: AppServer.getHttpHeadersWithToken(),
        body: {
          "fullName": fullName,
          "email": email,
          "phone": phoneNumber,
          "businessName": businessName,
          "country": country,
          "state": state,
          "nin": nin,
          "imageUrl": imageUrl
        });

    return response;
  }

  Future<dynamic> editServiceProviderProfile({
    required String fullName,
    required String businessName,

    // required String email,
    // required String phoneNumber,
    // required String country,
    // required String state,
  }) async {
    final response = await server.putRequest(
        endPoint: "${ApiList.profile}provider",
        headers: AppServer.getHttpHeadersWithToken(),
        body: {
          "fullName": fullName,
          "businessName": businessName,

          // "email": email,
          // "phone": phoneNumber,
          // "country": country,
          // "state": state,
        });

    return response;
  }

  Future<dynamic> addServiceProviderProfileImage({
    required File imageFile,
  }) async {
    final response = await server.multipartRequest(
      "${ApiList.profileImage}serviceProvider",
      imageFile,
    );

    return response;
  }

  Future<dynamic> forgotPassword({
    required String? identifier,
  }) async {
    final response = await server.postRequest(
        endPoint: ApiList.forgotPassword,
        headers: AppServer.getAuthHeaders(),
        body: {
          "identifier": identifier,
        });

    return response;
  }

  Future<dynamic> resetPassword({
    required String? identifier,
    required String? password,
    required String? confirmPassword,
  }) async {
    final response = await server.postRequest(
        endPoint: ApiList.resetPassword,
        headers: AppServer.getAuthHeaders(),
        body: {
          "identifier": identifier,
          "password": password,
          "confirmPassword": confirmPassword
        });

    return response;
  }

  Future<dynamic> uploadMedia({
    required File imageFile,
  }) async {
    final response = await server.multipartRequest(
      ApiList.uploadMedia,
      imageFile,
    );

    return response;
  }

  Future<dynamic> createServices({
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
  }) async {
    final response = await server.multipartRequestFileText(
      ApiList.createServices,
      images,
      serviceName,
      serviceCategory,
      serviceDescription,
      servicePrice,
      hourlyRate,
      isCustomPackage,
      isFlexiblePricing,
      serviceLocation,
      serviceAddress,
    );

    return response;
  }

  Future<dynamic> updateServices({
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
  }) async {
    final response = await server.multipartRequestFileText(
      ApiList.updateServices,
      images,
      serviceName,
      serviceCategory,
      serviceDescription,
      servicePrice,
      hourlyRate,
      isCustomPackage,
      isFlexiblePricing,
      serviceLocation,
      serviceAddress,
    );

    return response;
  }

  Future<dynamic> deleteService({
    required String serviceId,
  }) async {
    final response = await server.deleteRequest(
      endPoint: ApiList.deleteServices + serviceId,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    return response;
  }

  Future<dynamic> getAllCategories() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.getAllCategories,
      headers: AppServer.getAuthHeaders(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getConversation() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.getConversation,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    final ApiResponse response = await server.postRequest(
      endPoint: ApiList.sendMessage,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "receiverId": receiverId,
        "content": content,
      },
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("Send message success: $data");
      return data;
    } else {
      debugPrint("Send message error: ${response.errorMessage}");
      return response;
    }
  }

  Future<dynamic> getConversationMessages(String conversationId) async {
    final ApiResponse response = await server.getRequest(
      endPoint: "${ApiList.getConversationMessages}$conversationId",
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("Conversation messages: $data");
      return data;
    } else {
      debugPrint("Get messages error: ${response.errorMessage}");
      return response;
    }
  }

  Future<dynamic> getRatingsAndReviews() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.getRatingsAndReviews,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getTopServices() async {
    final ApiResponse response = await server.getRequestNoToken(
      endPoint: ApiList.getAllServices,
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> searchServices(
    String searchInput,
    String locationFilter,
    String priceRangeFilter,
    String categoryFilter,
  ) async {
    final ApiResponse response = await server.getRequest(
      endPoint:
          "${ApiList.searchServices}search?serviceName=$searchInput$locationFilter$priceRangeFilter$categoryFilter",
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getTopCategories() async {
    final ApiResponse response = await server.getRequestNoToken(
      endPoint: ApiList.getTopCategories,
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getDashboard() async {
    final ApiResponse response = await server.getRequest(
      endPoint: "${ApiList.profile}dashboard",
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getCustomerProfile() async {
    final ApiResponse response = await server.getRequest(
      endPoint: "${ApiList.profile}customer",
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getServiceProviderProfile() async {
    final ApiResponse response = await server.getRequest(
      endPoint: "${ApiList.profile}provider",
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getBookings({
    required String bookingStatus,
    required String userType,
    // String
  }) async {
    final ApiResponse response = await server.getRequest(
      endPoint: "${ApiList.getAllBookings}$userType$bookingStatus",
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      // debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getProvderServices() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.providerServices,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      // debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  // Future<dynamic> getCountryStates({
  //   required String country,
  // }) async {
  //   final ApiResponse response = await server.postRequest(
  //       body: {"country": country},
  //       endPoint: "https://countriesnow.space/api/v0.1/countries/states",
  //       headers: AppServer.getAuthHeaders());

  //   debugPrint("zzzzzzzzzzz ${response.data}");

  //   if (response.isSuccess) {
  //     final data = response.data;
  //     debugPrint("object333333333 $data");

  //     return data;
  //   } else {
  //     return response;
  //   }
  // }

  Future<dynamic> sendOneSignalPlayerId({
    required String oneSignalPlayerId,
  }) async {
    final ApiResponse response = await server.postRequest(
        body: {"oneSignalPlayerId": oneSignalPlayerId},
        endPoint: ApiList.sendOneSignalPlayerId,
        headers: AppServer.getHttpHeadersWithToken());

    return response;
  }

  //Notification Preference
  Future<dynamic> createNotifiPreference() async {
    final response = await server.postRequest(
      endPoint: ApiList.createNotifiPreference,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "bookingRequests": true,
        "messages": true,
        "payments": true,
        "customerReviews": true,
        "emailNotifications": true,
        "smsNotifications": true,
      },
    );

    return response;
  }

  Future<dynamic> getNotifiPreference() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.getNotifiPreference,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> updateNotifiPreference({
    required bool bookingRequests,
    required bool messages,
    required bool payments,
    required bool customerReviews,
  }) async {
    final response = await server.putRequest(
      endPoint: ApiList.updateNotifiPreference,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "bookingRequests": bookingRequests,
        "messages": messages,
        "payments": payments,
        "customerReviews": customerReviews,
        "emailNotifications": true,
        "smsNotifications": false,
      },
    );

    return response;
  }

  Future<dynamic> getNotifications() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.notifications,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      // debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> bookService({
    required String serviceId,
    required String paymentMethod,
    required String message,
    required String street,
    required String city,
    required String state,
    required String country,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.createBooking,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "serviceId": serviceId,
        "paymentMethod": paymentMethod,
        "message": message,
        "serviceAddress": {
          "street": street,
          "city": city,
          "state": state,
          "country": country,
        },
      },
    );

    return response;
  }

  Future<dynamic> rateAndReviewService({
    required String serviceId,
    required int rating,
    required String review,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.ratingAndReviewService + serviceId,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "value": rating,
        "comment": review,
      },
    );

    return response;
  }

  Future<dynamic> reportService({
    required String bookingId,
    required String reportMessage,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.reportService,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "bookingId": bookingId,
        "message": reportMessage,
      },
    );

    return response;
  }

  Future<dynamic> confirmBookingCompletion({
    required String bookingId,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.confirmBookingCompletion + bookingId,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    return response;
  }

  Future<dynamic> cancelBookings({
    required String bookingId,
    required String reason,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.cancelBooking + bookingId,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {"reason": reason},
    );

    return response;
  }

  Future<dynamic> acceptBookings({
    required String bookingId,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.acceptBooking + bookingId,
      headers: AppServer.getHttpHeadersWithToken(),
      // body: { },
    );

    return response;
  }

  Future<dynamic> startBookings({
    required String bookingId,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.startBooking + bookingId,
      headers: AppServer.getHttpHeadersWithToken(),
      // body: { },
    );

    return response;
  }

  Future<dynamic> completeBookings({
    required String bookingId,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.completeBooking + bookingId,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {},
    );

    return response;
  }

  Future<dynamic> declineBookings({
    required String bookingId,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.declineBooking + bookingId,
      headers: AppServer.getHttpHeadersWithToken(),
      // body: { },
    );

    return response;
  }

  Future<dynamic> payForBooking({
    required String bookingId,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.payForService + bookingId,
      headers: AppServer.getHttpHeadersWithToken(),
      // body: { },
    );

    return response;
  }

  Future<dynamic> getTransaction() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.getTransaction,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> walletWithdrawal({
    required int amount,
    required String pin,
    required String accountDetailsId,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.walletWithdrawal,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "amount": amount,
        "pin": pin,
        "accountDetailsId": accountDetailsId,
      },
    );

    return response;
  }

  Future<dynamic> setWalletPin({
    required String pin,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.setTransactionPin,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "pin": pin,
      },
    );

    return response;
  }

  Future<dynamic> getAllBanks() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.getAllBanks,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> getBankAccounts() async {
    final ApiResponse response = await server.getRequest(
      endPoint: ApiList.getBankAccount,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    if (response.isSuccess) {
      final data = response.data;
      debugPrint("object 222222222 $data");

      return data;
    } else {
      return response;
    }
  }

  Future<dynamic> addBankAccount({
    required String accountName,
    required String accountNumber,
    required String bankName,
    required bool isPrimaryAccount,
  }) async {
    final response = await server.postRequest(
      endPoint: ApiList.addBankAccount,
      headers: AppServer.getHttpHeadersWithToken(),
      body: {
        "accountName": accountName,
        "accountNumber": accountNumber,
        "bankName": bankName,
        "isPrimary": isPrimaryAccount,
      },
    );

    return response;
  }

  Future<dynamic> deleteBankAccount({
    required String bankAccountId,
  }) async {
    final response = await server.deleteRequest(
      endPoint: ApiList.deleteBankAccount + bankAccountId,
      headers: AppServer.getHttpHeadersWithToken(),
    );

    return response;
  }
}
