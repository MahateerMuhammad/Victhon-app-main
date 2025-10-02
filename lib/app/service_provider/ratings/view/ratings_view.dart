import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/ratings/view/reviews_view.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../utils/functions.dart';
import '../controller/ratings_controller.dart';

class RatingsView extends StatelessWidget {
  RatingsView({super.key});

  final reviewsController = Get.put(RatingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Colors.black),
          //   onPressed: () => Navigator.pop(context),
          // ),
          title: const TextWidget(
            text: "Service Reviews & Ratings",
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: AppColor.whiteColor,
          surfaceTintColor: AppColor.whiteColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: "Your Reviews & Ratings",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 4),
              TextWidget(
                text:
                    "See how customers have rated your service and read their feedback",
                fontSize: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 24),

              // Ratings Card
              // Obx(() {
              //   if (reviewsController.isLoading.isTrue) {
              //     return const SizedBox();
              //   } else {
              //     if (reviewsController.reviewsDetails.isEmpty) {
              //       return const SizedBox(); // Show loader while fetching
              //     } else {
              //       return
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.primaryColor.shade50,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextWidget(
                      text: reviewsController.averageRating.value.toString(),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star_rounded,
                          color: index < reviewsController.averageRating.floor()
                              ? AppColor.yellowGold
                              : Colors.grey[300],
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      text:
                          "Based on ${reviewsController.totalRatings.value} reviews",
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 12),

                    // Star Ratings Breakdown
                    Column(
                      children: reviewsController.ratingsDetails.map((data) {
                        double percentage =
                            reviewsController.totalRatings.value > 0
                                ? data["count"] /
                                    reviewsController.totalRatings.value
                                : 0.0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              TextWidget(text: "${data["stars"]}"),
                              const SizedBox(width: 4),
                              const Icon(Icons.star_rounded,
                                  color: Colors.black54, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    Container(
                                      height: 6,
                                      width: MediaQuery.of(context).size.width *
                                          0.5 *
                                          percentage,
                                      decoration: BoxDecoration(
                                        color: AppColor.yellowGold,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              TextWidget(text: "${data["count"]}"),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              //     }
              //   }
              // }),

              SizedBox(height: 16),

              // All Reviews Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(
                    text: "All Reviews",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  reviewsController.reviewsDetails.length > 3
                      ? TextButton(
                          onPressed: () {
                            Get.to(() => ReviewsScreen());
                          },
                          child: Row(
                            children: [
                              TextWidget(
                                text:
                                    "View all (${reviewsController.reviewsDetails.length})",
                                fontSize: 14,
                                color: AppColor.blueColor1,
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Colors.blue),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 30,
                        ),
                ],
              ),

              const SizedBox(height: 8),

              // Reviews List
              Obx(() {
                if (reviewsController.isLoading.isTrue) {
                  return const SizedBox();
                } else {
                  if (reviewsController.reviewsDetails.isEmpty) {
                    return const SizedBox(); // Show loader while fetching
                  } else {
                    return Column(
                      children: reviewsController.reviewsDetails.map((review) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.primaryCardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        AppColor.primaryColor.shade100,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: review["profilePic"],
                                        fit: BoxFit.cover,
                                        width: 44,
                                        height: 44,
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          color: AppColor.whiteColor,
                                          size: 28,
                                        ),
                                        placeholder: (context, url) =>
                                            const SizedBox(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: review["customerName"],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      TextWidget(
                                        text:
                                            "${review["serviceName"]} • ${formatDate(review["dateStamp"])}",
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Star Rating
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < review["rating"]
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: AppColor.yellowGold,
                                    size: 20,
                                  );
                                }),
                              ),

                              const SizedBox(height: 8),

                              // Review Text
                              TextWidget(
                                text: review["comment"],
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
