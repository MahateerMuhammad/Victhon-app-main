import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/bottonNavBar/controller/bottom_nav_bar.dart';
import 'package:Victhon/app/customerApp/inbox/view/inbox_screen.dart';
import 'package:Victhon/app/customerApp/home/view/home_screen.dart';
import 'package:Victhon/app/customerApp/profile/view/profile_screen.dart';
import 'package:Victhon/config/theme/app_color.dart';
import '../../bookings/controller/bookings_controller.dart';
import '../../bookings/view/services_screen.dart';
import '../../home/controller/home_controllers.dart';
import '../../inbox/controller/inbox_controller.dart';
import '../../profile/controller/profile_controller.dart';

class CustomerBottomNavBar extends StatefulWidget {
  const CustomerBottomNavBar({
    super.key,
    this.index,
  });
  final int? index;

  @override
  State<CustomerBottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<CustomerBottomNavBar> {
  final bottomNavBarController = Get.put(BottomNavBarController());

  final homeController = Get.put(HomeControllers());
  final bookingsController = Get.put(CustomerBookingsController());
  final inboxController = Get.put(InboxController());

  int selectedIndex = 0;
  late List screens;

  onClick(int currentIndex) {
    print("Got here !!!!!!!!!!!!!!!!!");
    setState(() {
      selectedIndex = currentIndex;

      print("Got here !!!!!!!!!!!!!!!!! $selectedIndex");

      if (selectedIndex == 0) {
        homeController.refreshFetchServices();
      } else if (selectedIndex == 1) {
        bookingsController.refreshFetchBookings();
      } else if (selectedIndex == 2) {
        inboxController.fetchConversation();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bottomNavBarController.notificationFunction();
    if (widget.index != null) {
      selectedIndex = widget.index!;
    }
    Get.put(HomeControllers());
    Get.put(CustomerBookingsController());
    Get.put(ProfileController());
    Get.put(InboxController());

    screens = [
      const HomeScreen(),
      const ServicesScreen(),
      MessagesScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.inactiveColor,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        selectedIconTheme: const IconThemeData(
          color: AppColor.primaryColor,
          size: 32,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 30,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        showUnselectedLabels: false,
        onTap: (int currentIndex) {
          onClick(currentIndex);
          // setState(() {
          //   selectedIndex = currentIndex;
          // });
        },
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
            backgroundColor: AppColor.whiteColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hardware_rounded),
            label: "services",
            backgroundColor: AppColor.whiteColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "inbox",
            backgroundColor: AppColor.whiteColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
            backgroundColor: AppColor.whiteColor,
          ),
        ],
      ),
      body: screens[selectedIndex],
    );
  }
}
