import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/bookings/widget/bookings_dailog.dart';
import 'package:Victhon/app/service_provider/bookings/widget/cancel_booking_textfield.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_outline_button.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../config/theme/app_color.dart';

void showCancelBookingDialog(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  text: "Cancel Booking",
                  fontSize: 16,
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
            const TextWidget(
              text: "Cancellation Reason",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 10),

            const CancelBookingTextfield(),

            const SizedBox(height: 10),

            // Time Frame Selection
            const TextWidget(
              text: "Note",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.backgroundYellow),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextWidget(
                  text:
                      "If you reject bookings more than three times, you will be temporarily suspended from accepting new orders for five hours.",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    buttonText: "Cancel",
                    onPressed: () {
                      Get.back();
                    },
                    borderColor: AppColor.primaryColor,
                    textColor: AppColor.primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: AppPrimaryButton(
                    buttonText: "Decline",
                    onPressed: () {
                      Get.back();
                      showStatusDialog(
                        context,
                        AppIcons.calendarRemove,
                        "Booking Declined",
                        "You have successfully declined this booking. The customer has been notified about your decision.",
                        "View Other Bookings",
                      );
                    },
                    buttonColor: AppColor.redColor1,
                    textColor: AppColor.whiteColor,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}
