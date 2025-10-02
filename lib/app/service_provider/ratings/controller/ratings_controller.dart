import 'dart:async';
import 'package:get/get.dart';
import '../../../../data/remote_services/remote_services.dart';

class RatingsController extends GetxController {
  final isLoading = false.obs;

  RxList<dynamic> ratingsDetails = <dynamic>[].obs;
  RxList<dynamic> reviewsDetails = <dynamic>[].obs;

  RxDouble averageRating = 0.0.obs;
  RxInt totalReviews = 0.obs;
  RxInt totalRatings = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRatingsAndReviews();
  }

  Future<void> fetchRatingsAndReviews() async {
    isLoading(true);
    print("heyyyyyyyy fetch transaction");
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // // Check if services exist in local storage
    // String? savedProfileDetails = prefs.getString("cached_profileDetails");
    // if (savedProfileDetails != null) {
    //   transactionDetails.value =
    //       List<Map>.from(json.decode(savedProfileDetails));
    // }

    // Fetch new services from API
    final response = await RemoteServices().getRatingsAndReviews();
    // print("@@@@@@@@@@ ${response} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response["averageRating"].runtimeType} @@@@@@@@@@");
    isLoading(false);

    if (response is Map<String, dynamic>) {
      ratingsDetails.value = response["ratingDistribution"];
      reviewsDetails.value = response["reviews"];
      averageRating.value = response["averageRating"].runtimeType == int
          ? double.parse(response["averageRating"].toString())
          : response["averageRating"];
      totalRatings.value = response["totalRatings"].runtimeType != int
          ? 0
          : response["totalRatings"];
      totalReviews.value = response["pagination"]["totalReviews"];
      // await prefs.setString(
      //     "cached_categories", json.encode(response["profile"]));
    }
  }
}
