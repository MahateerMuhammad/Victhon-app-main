import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/bottomNavBar/controller/service_provider_bottom_nav_bar_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/bookings/view/bookings_view.dart';
import 'package:Victhon/app/service_provider/dashboard/view/dashboard_view.dart';
import 'package:Victhon/app/service_provider/earnings/view/earnings_view.dart';
import 'package:Victhon/app/service_provider/profile/view/profile_view.dart';
import '../../bookings/controller/bookings_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../earnings/controller/earnings_controller.dart';
import '../../profile/controller/service_provider_profile_controller.dart';

class ServiceProviderBottomNavBar extends StatefulWidget {
  const ServiceProviderBottomNavBar({
    super.key,
    this.index,
  });
  final int? index;

  @override
  State<ServiceProviderBottomNavBar> createState() =>
      _ServiceProviderBottomNavBarState();
}

class _ServiceProviderBottomNavBarState
    extends State<ServiceProviderBottomNavBar> {
  final bottomNavBarController = Get.put(ServiceProviderBottomNavBarController());



  late List screens;

  @override
  void initState() {
    super.initState();

    bottomNavBarController.notificationFunction();

    if (widget.index != null) {
      bottomNavBarController.selectedIndex.value = widget.index!;
    }
    Get.put(DashboardController());
    Get.put(BookingsController());
    Get.put(EarningsController());
    Get.put(ServiceProviderProfileController());

    screens = [
      const DashboardView(),
      const BookingsView(),
      EarningsView(),
      const ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        backgroundColor: AppColor.whiteColor,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.whiteColor,
          elevation: 0,
          selectedItemColor: AppColor.primaryColor,
          unselectedItemColor: AppColor.primaryColor.shade200,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          selectedIconTheme: const IconThemeData(
            color: AppColor.primaryColor,
            size: 32,
          ),
          unselectedIconTheme: IconThemeData(
            size: 30,
            color: AppColor.primaryColor.shade200,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColor.primaryColor.shade200,
          ),
          showUnselectedLabels: true,
          onTap: (int currentIndex) {
            bottomNavBarController.changeTab(currentIndex);
      
            // setState(() {
            //   selectedIndex = currentIndex;
            // });
          },
          currentIndex: bottomNavBarController.selectedIndex.value,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: "Home",
              backgroundColor: AppColor.whiteColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range_outlined),
              activeIcon: Icon(Icons.date_range),
              label: "Bookings",
              backgroundColor: AppColor.whiteColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet_outlined),
              activeIcon: Icon(Icons.wallet),
              label: "Earnings",
              backgroundColor: AppColor.whiteColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
              backgroundColor: AppColor.whiteColor,
            ),
          ],
        ),
        body: screens[bottomNavBarController.selectedIndex.value],
      ),
    );
  }
}
