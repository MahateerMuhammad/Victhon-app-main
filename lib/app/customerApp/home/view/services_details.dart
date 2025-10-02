import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/home/view/request_service_screen.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/utils/images.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../bookings/controller/bookings_controller.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({
    super.key,
    required this.serviceDetails,
  });
  final Map<String, dynamic> serviceDetails;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  List<String> imageUrls = [];
  List ratingsReviews = [];
  int ratingsReviewsCount = 0;
  String viewText = "View all";

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("service Details: ${widget.serviceDetails}");
    imageUrls = List<String>.from(widget.serviceDetails["imageUrls"] ?? []);
    final ratings = widget.serviceDetails["ratings"] ?? {};
    ratingsReviews = ratings["reviews"] ?? [];
    ratingsReviewsCount = ratings["totalRatings"] ?? 0;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: imageUrls[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250,
                          errorWidget: (context, url, error) => Image.asset(
                            AppImages.onboardingImages1,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: const CircleAvatar(
                        minRadius: 20,
                        backgroundColor: AppColor.whiteColor,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: imageUrls.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppColor.primaryColor,
                          dotColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image and Service Name

                    TextWidget(
                      text: widget.serviceDetails["serviceName"],
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    TextWidget(
                      text: widget.serviceDetails["serviceDescription"],
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    widget.serviceDetails["serviceAddress"]["state"] == null
                        ? const SizedBox()
                        : Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColor.blackColor.withOpacity(0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.serviceDetails["serviceAddress"]["state"]}, ${widget.serviceDetails["serviceAddress"]["country"]}",
                                style: TextStyle(
                                  color: AppColor.blackColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                    const Divider(
                      height: 40,
                      color: AppColor.inactiveColor,
                    ),

                    // Details Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailItem(
                            Icon(
                              Icons.work,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            "${widget.serviceDetails["requestCompleted"]} Job${widget.serviceDetails["requestCompleted"] == 1 ? "" : "s"}",
                            "Total Jobs"),
                        _buildDetailItem(
                            const Icon(
                              Icons.check,
                              color: AppColor.primaryColor,
                            ),
                            "${widget.serviceDetails["availability"]}",
                            "Availability"),
                        _buildDetailItem(
                          const Icon(
                            Icons.star,
                            color: AppColor.yellowGold,
                          ),
                          "${widget.serviceDetails["averageRating"]}",
                          "Ratings",
                        ),
                      ],
                    ),
                    const Divider(
                      height: 40,
                      color: AppColor.inactiveColor,
                    ),

                    // Profile Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.serviceDetails["providerId"]["imageUrl"],
                            errorListener: (error) => const Icon(
                              Icons.person,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextWidget(
                                  text: widget.serviceDetails["providerId"]
                                      ["fullName"],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                widget.serviceDetails["providerId"]
                                            ["isVerified"] ==
                                        true
                                    ? const Icon(
                                        Icons.verified,
                                        color: AppColor.primaryColor,
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            Text(
                              widget.serviceDetails["providerId"]
                                  ["businessName"],
                              style: TextStyle(
                                color: AppColor.blackColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    // Cost Section
                    const Text(
                      "Cost of Service",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text("Starting from"),
                        const SizedBox(
                          width: 8,
                        ),
                        TextWidget(
                          text: formatAsMoney(double.parse(widget
                              .serviceDetails["servicePrice"]
                              .toString())),
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    widget.serviceDetails["hourlyRate"] != null
                        ? Row(
                            children: [
                              Text("Hourly rate"),
                              const SizedBox(
                                width: 8,
                              ),
                              TextWidget(
                                text: formatAsMoney(double.parse(widget
                                    .serviceDetails["hourlyRate"]
                                    .toString())),
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          )
                        : const SizedBox(),
                    const Divider(
                      height: 40,
                      color: AppColor.inactiveColor,
                    ),

                    // Ratings & Reviews Section
                    ratingsReviewsCount == 0
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Ratings & Reviews",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (ratingsReviewsCount == 1) {
                                    ratingsReviewsCount = 5;
                                    viewText = "View less";
                                  } else if (ratingsReviewsCount == 5) {
                                    ratingsReviewsCount = 1;
                                    viewText = "View all";
                                  }
                                  setState(() {});
                                },
                                child: Text(viewText),
                              ),
                            ],
                          ),
                    const SizedBox(height: 8),
                    ratingsReviewsCount == 0
                        ? const SizedBox()
                        : ListView.builder(
                            itemCount: ratingsReviewsCount,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              AppColor.primaryColor.shade100,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: ratingsReviews[index]
                                                  ["profilePic"],
                                              fit: BoxFit.cover,
                                              width: 44,
                                              height: 44,
                                              errorWidget:
                                                  (context, url, error) =>
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
                                              text: ratingsReviews[index]
                                                  ["customerName"],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            TextWidget(
                                              text:
                                                  "${ratingsReviews[index]["serviceName"]} • ${formatDate(ratingsReviews[index]["dateStamp"])}",
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
                                      children: List.generate(5, (ind) {
                                        return Icon(
                                          Icons.star_rounded,
                                          color: ind <
                                                  ratingsReviews[index]
                                                      ["rating"]
                                              ? AppColor.yellowGold
                                              : Colors.grey[300],
                                          size: 20,
                                        );
                                      }),
                                    ),

                                    const SizedBox(height: 8),

                                    // Review Text
                                    TextWidget(
                                      text: ratingsReviews[index]["comment"],
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: AppPrimaryButton(
          buttonText: "Request Service",
          onPressed: () {
            Get.to(() => RequestServiceScreen(
                      serviceDetails: widget.serviceDetails,
                    ))!
                .then((_) {
              Get.find<CustomerBookingsController>().fetchBookings();
            });
            ;
          },
        ),
      ),
    );
  }

  Widget _buildDetailItem(Widget icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget(
          text: label,
          fontWeight: FontWeight.w400,
        ),
        Row(
          children: [
            icon,
            const SizedBox(width: 4),
            TextWidget(
              text: value,
              fontSize: 16,
              color: AppColor.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}
