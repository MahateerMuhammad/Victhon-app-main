import 'package:flutter/material.dart';
import 'package:Victhon/app/service_provider/bookings/widget/time_frame_component.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../config/theme/app_color.dart';

void showFilterDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Ensures rounded corners look good
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  text: "Filter by Date",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Time Frame Selection
            const Align(
              alignment: Alignment.centerLeft,
              child: TextWidget(
                text: "Time Frame",
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),

            const TimeFrameComponent(),
           

           

            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}


