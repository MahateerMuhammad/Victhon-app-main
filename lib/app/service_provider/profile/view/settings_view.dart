import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:Victhon/app/service_provider/profile/view/edit_profile.dart';
import 'package:Victhon/app/service_provider/profile/widget/logout_dialog.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/profile/view/bank_account.dart';
import 'package:Victhon/app/service_provider/profile/view/contact_us.dart';
import 'package:Victhon/app/service_provider/profile/view/notification_settings.dart';
import 'package:Victhon/app/service_provider/profile/view/transaction_settings.dart';

import '../../../../widget/app_outline_button.dart';
import '../../../../widget/loader.dart';
import '../controller/service_provider_profile_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final providerProfileController = Get.put(ServiceProviderProfileController());

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
                      Get.to(() => const ServiceProviderEditProfile());
                    },
                  ),
                  _settingsTile(
                    LucideIcons.wallet,
                    "Transaction Settings",
                    () {
                      Get.to(() => const TransactionSettings());
                    },
                  ),
                  _settingsTile(
                    LucideIcons.building2,
                    "Bank Account",
                    () {
                      Get.to(() => BankAccount());
                    },
                  ),
                ]),

                // Notifications
                _settingsSection([
                  _settingsTile(
                    LucideIcons.bell,
                    "Notification Settings",
                    () {
                      Get.to(() => NotificationSettings());
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
                //     "Login Settings",
                //     () {
                //       // Get.to(() => LoginSettings());
                //     },
                //   ),
                // ]),

                // Contact Us
                _settingsSection([
                  _settingsTile(
                    LucideIcons.headphones,
                    "Contact Us",
                    () {
                      Get.to(() => ContactUs());
                    },
                  ),
                ]),
                const SizedBox(height: 20),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppOutlinedButton(
                    buttonText: "Log Out",
                    onPressed: () {
                      showProviderLogoutDialog(context);
                    },
                    borderColor: AppColor.primaryColor,
                    textColor: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          providerProfileController.isLoading.value
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
