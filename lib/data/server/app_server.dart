import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/custom_snackbar.dart';
import '../../main.dart';
import '../remote_services/network_service.dart';

class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  final String? errorMessage;

  ApiResponse({this.data, this.statusCode, this.errorMessage});

  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;
}

class AppServer {
  static const Duration timeoutDuration = Duration(seconds: 60);

  final networkService = Get.find<NetworkService>();

  getRequest({
    required String endPoint,
    required Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final dio = Dio();

    // ✅ Check if connected to the internet
    final hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      print("⚠️ No internet connection");
      return ApiResponse(
        statusCode: 0,
        errorMessage: "No internet connection",
      );
    }

    try {
      print("----------------- $headers");
      print("----------------- $endPoint");

      final response = await dio
          .get(
            endPoint,
            options: Options(headers: headers),
            queryParameters: queryParameters,
          )
          .timeout(timeoutDuration);

      print("----------------- ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("got here ---------1");
        return ApiResponse(
          data: response.data,
          statusCode: response.statusCode,
        );
      } else {
        print("got here ---------2");
        return ApiResponse(
          statusCode: response.statusCode,
          errorMessage: "Unexpected Error",
        );
      }
    } on DioException catch (e) {
      print("got here $e ---------3");
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        errorMessage: e.response?.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      print("got here ---------4");
      return ApiResponse(
        statusCode: 500,
        errorMessage: 'Error: $e',
      );
    }
  }

  getRequestNoToken({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    final dio = Dio();

    try {
      print("----------------- $endPoint");
      final response = await dio
          .get(
            endPoint,
            queryParameters: queryParameters,
            options: Options(
              headers: _getHttpHeadersNotToken(),
            ),
          )
          .timeout(timeoutDuration);
      print("----------------- $response");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            statusCode: response.statusCode, errorMessage: "Unexpected Error");
      }
    } on DioException catch (e) {
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        errorMessage: e.response?.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, errorMessage: 'Error: $e');
    }
  }

  postRequest(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      Object? body}) async {
    final dio = Dio();

    final hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      print("⚠️ No internet connection");
      customSnackbar("ERROR".tr, "No Internet Connection", AppColor.error);
      return ApiResponse(
        statusCode: 0,
        errorMessage: "No internet connection",
      );
    }

    try {
      print("----------------- $headers");
      print("----------------- $endPoint");
      print("----------------- $body");

      final response = await dio
          .post(
            endPoint,
            options: Options(headers: headers),
            queryParameters: queryParameters,
            data: body,
          )
          .timeout(timeoutDuration);
      // print("Post hereeeeeee ${response}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            statusCode: response.statusCode, errorMessage: "Unexpected Error");
      }
    } on DioException catch (e) {
      print("errrrrrrorrrrr ${e.response?.statusCode}");
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        errorMessage: e.response?.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(
          statusCode: 500, errorMessage: 'Error: Something went wrong');
    }
  }

  Future<dynamic> multipartRequest(
    String endPoint,
    File filepath,
  ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(endPoint))
        ..headers.addAll(getHttpHeadersWithToken())
        ..files.add(await http.MultipartFile.fromPath('file', filepath.path));

      // Send request
      var streamedResponse = await request.send();

      // Convert StreamedResponse to Response
      var response = await http.Response.fromStream(streamedResponse);

      // Print and return response
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
            data: response.body, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            statusCode: response.statusCode, errorMessage: "Unexpected Error");
      }
    } on DioException catch (e) {
      print("errrrrrrorrrrr ${e.response?.statusCode}");
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        errorMessage: e.response?.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, errorMessage: 'Error: $e');
    }
  }

  Future<dynamic> multipartRequestFileText(
    String endPoint,
    List<File?>? images,
    String serviceName,
    String serviceCategory,
    String serviceDescription,
    int servicePrice,
    int hourlyRate,
    bool isFlexiblePricing,
    bool isCustomPackage,
    List<String> serviceLocation,
    Map<String, dynamic> serviceAddress,
  ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(endPoint));
      request.headers.addAll(getHttpHeadersWithToken());

      // JSON data
      Map<String, dynamic> jsonBody = {
        "serviceName": serviceName,
        "serviceCategory": serviceCategory,
        "serviceDescription": serviceDescription,
        "servicePrice": servicePrice,
        "hourlyRate": hourlyRate,
        "isFlexiblePricing": isFlexiblePricing,
        "isCustomPackage": isCustomPackage,
        "serviceLocation": serviceLocation,
        "serviceAddress": serviceAddress,
      };

      // Add JSON as a text field
      request.fields['data'] = jsonEncode(jsonBody);

      // Add image files if available
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          if (image != null) {
            request.files.add(
              await http.MultipartFile.fromPath('file', image.path),
            );
          }
        }
      }
      print("----------------- ${request.fields}");
      print("----------File------- ${request.fields}");

      // Send request
      var streamedResponse = await request.send();

      // Convert StreamedResponse to Response
      var response = await http.Response.fromStream(streamedResponse);

      // Print and return response
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
            data: response.body, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            statusCode: response.statusCode, errorMessage: "Unexpected Error");
      }
    } on DioException catch (e) {
      print("errrrrrrorrrrr ${e.response?.statusCode}");
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        errorMessage: e.response?.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, errorMessage: 'Error: $e');
    }
  }

  static String? bearerToken;

  static initClass({String? token}) {
    final box = GetStorage();
    return bearerToken = box.read('token');
  }

  postRequestWithToken({String? endPoint, String? body}) async {
    HttpClient client = HttpClient();
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return await http.post(Uri.parse(endPoint!),
          headers: getHttpHeadersWithToken(), body: body);
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  putRequest({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? headers,
  }) async {
    final dio = Dio();
    final hasConnection = await InternetConnectionChecker().hasConnection;
    if (!hasConnection) {
      print("⚠️ No internet connection");
      customSnackbar("ERROR".tr, "No Internet Connection", AppColor.error);
      return ApiResponse(
        statusCode: 0,
        errorMessage: "No internet connection",
      );
    }

    try {
      print("----------------- $headers");
      print("----------------- $endPoint");
      final response = await dio
          .put(
            endPoint,
            options: Options(headers: headers),
            data: body,
          )
          .timeout(timeoutDuration);
      print("----------------- ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            statusCode: response.statusCode, errorMessage: "Unexpected Error");
      }
    } on DioException catch (e) {
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        errorMessage: e.response?.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, errorMessage: 'Error: $e');
    }
  }

  deleteRequest({required String endPoint, headers}) async {
    final dio = Dio();
    try {
      print("----------------- $headers");
      print("----------------- $endPoint");
      final response = await dio.delete(
        endPoint,
        options: Options(headers: headers),
      );
      print("----------------- ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
            data: response.data, statusCode: response.statusCode);
      } else {
        return ApiResponse(
            statusCode: response.statusCode, errorMessage: "Unexpected Error");
      }
    } on DioException catch (e) {
      return ApiResponse(
        statusCode: e.response?.statusCode ?? 500,
        errorMessage: e.response?.data?['message'] ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(statusCode: 500, errorMessage: 'Error: $e');
    }
  }

  static Map<String, String> _getHttpHeadersNotToken() {
    Map<String, String> headers = Map<String, String>();
    // headers['x-api-key'] = ApiList.licenseCode.toString();
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = "*/*";
    // headers['Access-Control-Allow-Origin'] = "*";
    return headers;
  }

  static Map<String, String> getAuthHeaders() {
    Map<String, String> headers = Map<String, String>();
    // headers['x-api-key'] = ApiList.licenseCode.toString();
    headers['Content-Type'] = 'application/json';
    // headers['Accept'] = "*/*";
    // headers['Access-Control-Allow-Origin'] = "*";

    return headers;
  }

  static Map<String, String> getHttpHeadersWithToken() {
    var token = box.read('token');
    Map<String, String> headers = Map<String, String>();
    headers['Authorization'] = "Bearer $token";
    // headers['x-api-key'] = ApiList.licenseCode.toString();
    headers['Content-Type'] = 'application/json';
    // headers['Accept'] = "*/*";
    // headers['Access-Control-Allow-Origin'] = "*";
    return headers;
  }
}
