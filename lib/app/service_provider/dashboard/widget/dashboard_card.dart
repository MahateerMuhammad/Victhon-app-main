import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/bottomNavBar/controller/service_provider_bottom_nav_bar_controller.dart';
import 'package:Victhon/app/service_provider/ratings/view/ratings_view.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../config/theme/app_color.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.primaryCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.blackColor,
                  fontWeight: FontWeight.w300,
                )),
            trailing: Icon(icon, size: 32, color: iconColor),
            subtitle: Text(value,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const Divider(
            height: 1,
            color: AppColor.grayColor,
          ),
          InkWell(
            onTap: () {
              if (title == "Average Rating") {
                Get.to(() => RatingsView());
              } else if (title == "Total Reviews"){
                Get.to(() => RatingsView());

              }  else if (title == "Total Bookings"){
                Get.find<ServiceProviderBottomNavBarController>().changeTab(1); // Switch to "Earnings" tab

                // Get.off(() => const ServiceProviderBottomNavBar(index: 1,));

              }  else if (title == "Total Earnings"){
                 Get.find<ServiceProviderBottomNavBarController>().changeTab(2);

              } 
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextWidget(
                    text: "View all",
                    fontSize: 12,
                    color: AppColor.blueColor,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: AppColor.blueColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
