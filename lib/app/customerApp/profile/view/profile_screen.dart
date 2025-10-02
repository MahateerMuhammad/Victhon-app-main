import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/views/signup_screen.dart';
import 'package:Victhon/app/customerApp/profile/controller/profile_controller.dart';
import 'package:Victhon/app/customerApp/profile/view/customer_settings.dart';
import 'package:Victhon/utils/icons.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final formkey = GlobalKey<FormState>();
  final profileController = Get.put(ProfileController());

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
              centerTitle: true,
              title: const TextWidget(
                text: "Your Profile",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () {
                            if (profileController.profileDetails.isEmpty) {
                              return const SizedBox(); // Show loader while fetching
                            } else {
                              // Horizontal List of Services
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        AppColor.primaryColor.shade100,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: profileController
                                            .profileImageUrl.value,
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
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: profileController
                                            .profileDetails["fullName"],
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      TextWidget(
                                        text: profileController
                                            .profileDetails["email"],
                                        fontSize: 12,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.to(() => CustomerSettings()),
                          child: const Icon(
                            Icons.settings,
                            size: 30,
                            color: AppColor.primaryColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            const SignupScreen(userType: "serviceProvider"));
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: "Become a Service Provider",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    TextWidget(
                                      text:
                                          "Sign up as a service provider to offer your services and earn.",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: Image.asset(
                                  AppIcons.serviceProviderIcon,
                                  scale: 4,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          profileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
