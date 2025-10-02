import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/profile/controller/service_provider_profile_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/profile/view/settings_view.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/loader.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final providerProfileController = Get.put(ServiceProviderProfileController());

  bool availabilityStatus = false;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColor.whiteColor,
              elevation: 0,
              surfaceTintColor: AppColor.whiteColor,
              automaticallyImplyLeading: false,
              title: const TextWidget(
                text: "Profile",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: AppColor.primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    Get.to(() => SettingsScreen());
                  },
                )
              ],
            ),
            body: Obx(
              () {
                if (providerProfileController.profileDetails.isEmpty) {
                  return const SizedBox(); // Show loader while fetching
                } else {
                  // Horizontal List of Services
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Profile Image
                        providerProfileController.profileDetails["imageUrl"] ==
                                null
                            ? Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                              )
                            : Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: CachedNetworkImageProvider(
                                    providerProfileController
                                        .profileImageUrl.value,
                                    errorListener: (error) => const Icon(
                                      Icons.person,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 10),

                        // Name and Email
                        TextWidget(
                          text: providerProfileController
                              .profileDetails["fullName"],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        Text(
                          providerProfileController.profileDetails["email"],
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        const SizedBox(height: 20),

                        // Personal Information
                        _sectionTitle("Personal Information"),
                        _infoCard([
                          _infoRow(
                              "Name",
                              providerProfileController
                                  .profileDetails["fullName"]),
                          _infoRow(
                              "Contact",
                              providerProfileController
                                  .profileDetails["phone"]),
                          _infoRow(
                              "Business Name",
                              providerProfileController
                                  .profileDetails["businessName"]),
                          _infoRow(
                              "Services",
                              providerProfileController
                                  .profileDetails["servicesCount"]
                                  .toString()),
                          _infoRow(
                              "Rating",
                              providerProfileController
                                  .profileDetails["averageRating"]
                                  .toString()),
                        ]),

                        // const SizedBox(height: 20),

                        // // Services Information
                        // _sectionTitle("Services Information"),
                        // _infoCard([
                        //   _infoRowWithSwitch("Availability Status"),
                        //   _infoRow("Service", "Plumbing Services", isBold: true),
                        //   _infoRow("Rating", "4.8"),
                        // ]),

                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          providerProfileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }

  // Section Title Widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  // Information Card Widget
  Widget _infoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Info Row Widget
  Widget _infoRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
