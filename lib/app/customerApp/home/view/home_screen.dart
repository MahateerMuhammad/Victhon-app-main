import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/home/controller/home_controllers.dart';
import 'package:Victhon/app/customerApp/home/view/search_screen.dart';
import 'package:Victhon/app/customerApp/home/view/services_details.dart';
import 'package:Victhon/app/customerApp/home/widget/services_list_shimmer.dart';
import 'package:Victhon/app/customerApp/notifications/view/customer_notification_view.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/constants.dart';
import 'package:Victhon/utils/images.dart';
import '../../../../utils/functions.dart';
import '../widget/build_service_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final homeController = Get.put(HomeControllers());

  final scrollController = ScrollController();
  final homeController = Get.find<HomeControllers>();

  Timer? _throttleTimer;
  bool showTopLoader = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    scrollController.addListener(() {
      if (scrollController.position.pixels == 0) {
        _onTopReached();
      }
    });
  }

  void _onTopReached() {
    print("on Reached !!!!!!!!!!!!!!!!!!!");
    if (_throttleTimer?.isActive ?? false) return;

    setState(() => showTopLoader = true);

    homeController.refreshFetchServices();

    _throttleTimer = Timer(const Duration(seconds: 2), () {
      setState(() => showTopLoader = false);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppColor.whiteColor,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            // Navigate to the search screen
            Get.to(() => const SearchScreen());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: AppColor.inactiveColor,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Text(
                  "What do you need help with?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => CustomerNotificationView());
                },
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColor.primaryColor,
                  size: 30,
                )),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                 

                  // Service list using Obx
                  Obx(() {
                    if (homeController.isLoading.value) {
                      return ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return buildShimmerServiceItem();
                        },
                      ); // Show loader while fetching
                    } else {
                      if (homeController.services.isEmpty) {
                        return SizedBox(); //Empty services state
                      } else {
                        // Vertical List of Services
                        return ListView.builder(
                          itemCount: homeController.services.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                                image: (homeController.services[index]
                                            ["imageUrls"] != null &&
                                        homeController.services[index]
                                                ["imageUrls"].isNotEmpty)
                                    ? homeController.services[index]
                                        ["imageUrls"][0]
                                    : AppImages.onboardingImages1,
                                title: homeController.services[index]
                                    ["serviceName"],
                                location: homeController.services[index]
                                    ["serviceDescription"],
                                // "${homeController.services[index]["serviceAddress"]["state"]}, ${homeController.services[index]["serviceAddress"]["country"]}",
                                jobsCompleted: homeController.services[index]
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
                                  double.parse(homeController.services[index]
                                          ["servicePrice"]
                                      .toString()),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  })
                ],
              ),
            ),
          ),
          homeController.isRefreshLoading.value == true
              ? const Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColor.whiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    // Check permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        // locationMessage = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          // locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("got here");
      _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {}
  }

  Future<String> _getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      print("got here search");
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        print("hereeeee");
        country.value = place.country!;
        state.value = place.administrativeArea!;
        city.value = place.locality!;
        street.value = place.street!;
        //     "${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
      return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      print("hereeee $e");
      return "Failed to get address: $e";
    }
  }
}
