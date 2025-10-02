import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:Victhon/app/customerApp/profile/view/edit_profile.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/profile/view/contact_us.dart';
import 'package:Victhon/app/service_provider/profile/view/notification_settings.dart';

import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../controller/profile_controller.dart';
import '../widget/logout_dialog.dart';

class CustomerSettings extends StatelessWidget {
  CustomerSettings({super.key});

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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColor.blackColor),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.blackColor,
                ),
              ),
              centerTitle: true,
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 10),

                // Account Settings
                _settingsSection([
                  _settingsTile(
                    LucideIcons.edit,
                    "Edit Profile",
                    () {
                      Get.to(() => EditProfile());
                    },
                  ),
                  _settingsTile(
                    LucideIcons.bell,
                    "Notification Settings",
                    () {
                      Get.to(() => NotificationSettings());
                    },
                  ),
                  _settingsTile(
                    LucideIcons.headphones,
                    "Contact Us",
                    () {
                      Get.to(() => ContactUs());
                    },
                  ),
                ]),

                // // Policies
                // _settingsSection([
                //   _settingsTile(
                //     LucideIcons.fileText,
                //     "Terms & Condition",
                //     () {
                //       // Get.to(() => LoginSettings());
                //     },
                //   ),
                //   _settingsTile(
                //     LucideIcons.shield,
                //     "Data Protection Policy",
                //     () {
                //       // Get.to(() => LoginSettings());
                //     },
                //   ),
                // ]),

                // Contact Us
                _settingsSection([
                  GestureDetector(
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.flip(
                            flipX: true,
                            child: const Icon(
                              Icons.logout,
                              color: AppColor.redColor1,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const TextWidget(
                            text: "Log out",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ),
          profileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }

  // Reusable Settings Section (Container with Rounded Corners)
  Widget _settingsSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: children),
    );
  }

  // Reusable Settings Tile
  Widget _settingsTile(IconData icon, String title, Function()? onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColor.primaryColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: AppColor.blackColor.withOpacity(0.8),
      ),
      onTap: onTap, // Implement navigation here
    );
  }
}
