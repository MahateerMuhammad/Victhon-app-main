import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/home/controller/home_controllers.dart';
import 'package:Victhon/app/customerApp/home/view/services_details.dart';
import 'package:Victhon/app/customerApp/home/widget/build_service_item.dart';
import 'package:Victhon/app/customerApp/home/widget/category_filter_body.dart';
import 'package:Victhon/app/customerApp/home/widget/empty_search_widget.dart';
import 'package:Victhon/utils/constants.dart';
import 'package:Victhon/utils/images.dart';
import 'package:Victhon/widget/app_search_text_field.dart';
import 'package:Victhon/widget/no_network_screen.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../data/remote_services/network_service.dart';
import '../../../../utils/functions.dart';
import '../widget/location_filter_body.dart';
import '../widget/price_range_filter_body.dart';
import '../widget/services_list_shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final homeController = Get.put(HomeControllers());
  final networkService = Get.find<NetworkService>();

  // String locationMessage = "Fetching location...";
  String? searchFilterOption;
  int? selectedChipIndex;

  // @override
  // void initState() {
  //   if (currentLocation != null) {
  //     _getAddressFromLatLng(
  //         currentLocation!.latitude, currentLocation!.longitude);
  //   }

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        surfaceTintColor: AppColor.whiteColor,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: AppSearchTextField(
          searchController: homeController.searchController.value,
          onChanged: (value) {
            setState(() {
              searchFilterOption = null;
            });

            homeController.searchServices(
              value,
              homeController.locationFilter.value.isNotEmpty
                  ? "&location=${homeController.locationFilter}"
                  : "",
              homeController.priceRangeFilter.isNotEmpty
                  ? "&maxPrice=${homeController.priceRangeFilter["maxPrice"]}&minPrice=${homeController.priceRangeFilter["minPrice"]}"
                  : '',
              homeController.categoryFilter.value.isNotEmpty
                  ? "&category=${homeController.categoryFilter}"
                  : '',
            );
          },
          prefixIcon: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColor.blackColor,
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                searchFilterOption = null;
              });
              homeController.searchServices(
                homeController.searchController.value.text,
                homeController.locationFilter.value.isNotEmpty
                    ? "&location=${homeController.locationFilter}"
                    : "",
                homeController.priceRangeFilter.isNotEmpty
                    ? "&maxPrice=${homeController.priceRangeFilter["maxPrice"]}&minPrice=${homeController.priceRangeFilter["minPrice"]}"
                    : '',
                homeController.categoryFilter.value.isNotEmpty
                    ? "&category=${homeController.categoryFilter}"
                    : '',
              );
            },
            child: const Icon(
              Icons.search,
              color: AppColor.blackColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.grayColor,
                  ),
                  child: const Icon(
                    Icons.near_me_outlined,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Search by Current Location",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextWidget(
                        text: "$street, $city, $state, $country",
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(
              color: AppColor.inactiveColor,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeController.searchFilterList.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedChipIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChipIndex = index;
                        });
                        if (index == 0) {
                          searchFilterOption = "Location";
                        } else if (index == 1) {
                          searchFilterOption = "Price Range";
                        } else if (index == 2) {
                          searchFilterOption = "Category";
                        }
                        setState(() {});
                      },
                      child: FilterChip(
                        label: homeController.searchFilterList[index],
                        isSelected: isSelected,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            searchFilterOption == null
                ? // Service list using Obx
                Obx(() {
                    if (homeController.searchController.value.text.isEmpty) {
                      if (homeController.isLoading.value) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return buildShimmerServiceItem();
                            },
                          ),
                        ); // Show loader while fetching
                      } else {
                        if (homeController.services.isEmpty) {
                          return SizedBox();
                        } else {
                          // Vertical List of Services
                          return Expanded(
                            child: ListView.builder(
                              itemCount: homeController.services.length,
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => ServiceDetailScreen(
                                        serviceDetails:
                                            homeController.services[index],
                                      ),
                                    );
                                  },
                                  child: buildServiceItem(
                                    image: homeController.services[index]
                                        ["imageUrls"][0],
                                    title: homeController.services[index]
                                        ["serviceName"],
                                    location:
                                        "${homeController.services[index]["serviceAddress"]["state"]}, ${homeController.services[index]["serviceAddress"]["country"]}",
                                    jobsCompleted:
                                        homeController.services[index]
                                                    ["availability"] ==
                                                true
                                            ? "Now"
                                            : "Unavailable",
                                    rating: homeController.services[index]
                                                ["averageRating"] ==
                                            null
                                        ? 0.0
                                        : double.parse(homeController
                                            .services[index]["averageRating"]
                                            .toString()),
                                    price: formatAsMoney(
                                      double.parse(homeController
                                          .services[index]["servicePrice"]
                                          .toString()),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                    } else {
                      if (networkService.isConnected.value) {
                        if (homeController.isLoading.value) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: 3,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildShimmerServiceItem();
                              },
                            ),
                          ); // Show loader while fetching
                        } else {
                          if (homeController.searchServicesResult.isEmpty) {
                            return Center(
                                child: EmptySearchWidget(
                              searchInput:
                                  homeController.searchController.value.text,
                            ));
                          } else {
                            // Vertical List of Services
                            return Expanded(
                              child: ListView.builder(
                                itemCount:
                                    homeController.searchServicesResult.length,
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ServiceDetailScreen(
                                          serviceDetails: homeController
                                              .searchServicesResult[index],
                                        ),
                                      );
                                    },
                                    child: buildServiceItem(
                                      image: homeController
                                                  .searchServicesResult[index]
                                              ["imageUrls"][0] ??
                                          AppImages.onboardingImages1,
                                      title: homeController
                                              .searchServicesResult[index]
                                          ["serviceName"],
                                      location:
                                          "${homeController.searchServicesResult[index]["serviceAddress"]["state"]}, ${homeController.searchServicesResult[index]["serviceAddress"]["country"]}",
                                      jobsCompleted:
                                          homeController.searchServicesResult[
                                                      index]["availability"] ==
                                                  true
                                              ? "Now"
                                              : "Unavailable",
                                      rating:
                                          homeController.searchServicesResult[
                                                      index]["averageRating"] ==
                                                  null
                                              ? 0.0
                                              : double.parse(homeController
                                                  .searchServicesResult[index]
                                                      ["averageRating"]
                                                  .toString()),
                                      price: formatAsMoney(
                                        double.parse(homeController
                                            .searchServicesResult[index]
                                                ["servicePrice"]
                                            .toString()),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      } else {
                        return const Center(
                          child: NoNetworkWidget(),
                        );
                      }
                    }
                  })
                : const SizedBox(),
            searchFilterOption == null
                ? const SizedBox()
                : Expanded(
                    child: filterBodyFunction(),
                  ),
          ],
        ),
      ),
    );
  }

  filterBodyFunction() {
    if (searchFilterOption == "Location") {
      return const LocationFilterBody();
    } else if (searchFilterOption == "Price Range") {
      return const PriceRangeFilterBody();
    } else {
      return const CategoryFilterBody();
    }
  }
}

class FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColor.primaryColor
            : Colors.transparent, // Background color when selected
        border: isSelected
            ? null // No border when selected
            : Border.all(
                width: 1,
                color: AppColor.inactiveColor,
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Change text color when selected
              fontSize: 14,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: isSelected
                ? Colors.white
                : AppColor.blackColor, // Change icon color when selected
          ),
        ],
      ),
    );
  }
}
