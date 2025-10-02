import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../controller/bookings_controller.dart';

class EmptyBookingsWidget extends StatelessWidget {
  const EmptyBookingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 120,
        ),
        Image.asset(
          AppIcons.calendarIcon,
          scale: 4,
        ),
        const SizedBox(
          height: 16,
        ),
        const TextWidget(
          text: "No Bookings Yet",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 4,
        ),
        const TextWidget(
          text: "You haven't made any booking request yet.",
          fontSize: 16,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
        AppOutlinedButton(
          buttonText: "Refresh Page",
          borderColor: AppColor.primaryColor,
          textColor: AppColor.primaryColor,
          onPressed: () {
            Get.find<CustomerBookingsController>().fetchBookings();
          },
        ),
      ],
    );
  }
}
