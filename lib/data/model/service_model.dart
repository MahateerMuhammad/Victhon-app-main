import 'dart:convert';

class ServiceResponseModel {
  final String id;
  final String providerId;
  final String serviceName;
  final ServiceCategory serviceCategory;
  final String serviceDescription;
  final int servicePrice;
  final bool? isFlexiblePricing;
  final bool? isCustomPackage;
  final int hourlyRate;
  final List<String> serviceLocation;
  final String serviceAddress;
  final List<String> imageUrls;
  final String availability;
  final int requestInitiated;
  final int requestCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalRatings;
  final double averageRating;

  ServiceResponseModel({
    required this.id,
    required this.providerId,
    required this.serviceName,
    required this.serviceCategory,
    required this.serviceDescription,
    required this.servicePrice,
    this.isFlexiblePricing,
    this.isCustomPackage,
    required this.hourlyRate,
    required this.serviceLocation,
    required this.serviceAddress,
    required this.imageUrls,
    required this.availability,
    required this.requestInitiated,
    required this.requestCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.totalRatings,
    required this.averageRating,
  });

  factory ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceResponseModel(
      id: json["_id"],
      providerId: json["providerId"] ?? "",
      serviceName: json["serviceName"],
      serviceCategory: ServiceCategory.fromJson(json["serviceCategory"]),
      serviceDescription: json["serviceDescription"],
      servicePrice: json["servicePrice"],
      isFlexiblePricing: json["isFlexiblePricing"] ?? false,
      isCustomPackage: json["isCustomPackage"] ?? false,
      hourlyRate: json["hourlyRate"],
      serviceLocation: List<String>.from(json["serviceLocation"]),
      serviceAddress: json["serviceAddress"],
      imageUrls: List<String>.from(json["imageUrls"]),
      availability: json["availability"],
      requestInitiated: json["requestInitiated"],
      requestCompleted: json["requestCompleted"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      totalRatings: json["totalRatings"],
      averageRating: (json["averageRating"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "providerId": providerId,
      "serviceName": serviceName,
      "serviceCategory": serviceCategory.toJson(),
      "serviceDescription": serviceDescription,
      "servicePrice": servicePrice,
      "isFlexiblePricing": isFlexiblePricing,
      "isCustomPackage": isCustomPackage,
      "hourlyRate": hourlyRate,
      "serviceLocation": serviceLocation,
      "serviceAddress": serviceAddress,
      "imageUrls": imageUrls,
      "availability": availability,
      "requestInitiated": requestInitiated,
      "requestCompleted": requestCompleted,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "totalRatings": totalRatings,
      "averageRating": averageRating,
    };
  }
}

class ServiceCategory {
  final String id;
  final String categoryName;

  ServiceCategory({
    required this.id,
    required this.categoryName,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json["_id"],
      categoryName: json["categoryName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "categoryName": categoryName,
    };
  }
}

// Function to parse list of services
List<ServiceResponseModel> parseServices(String jsonData) {
  final Map<String, dynamic> decodedData = jsonDecode(jsonData);
  final List<dynamic> data = decodedData["data"];
  return data.map((json) => ServiceResponseModel.fromJson(json)).toList();
}
