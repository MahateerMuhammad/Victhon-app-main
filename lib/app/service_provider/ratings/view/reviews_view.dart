import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/ratings/controller/ratings_controller.dart';
import 'package:Victhon/utils/functions.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final reviewsController = Get.put(RatingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const TextWidget(
          text: "All Reviews",
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
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
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: CachedNetworkImageProvider(
                                  review["profilePic"],
                                  errorListener: (error) => const Icon(
                                    Icons.person,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ),
    );
  }
}
