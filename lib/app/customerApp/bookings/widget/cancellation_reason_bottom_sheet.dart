import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/bookings/controller/bookings_controller.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/textwidget.dart';

class CancellationReasonBottomSheet extends StatefulWidget {
  const CancellationReasonBottomSheet({
    super.key,
    required this.bookingId,
  });
  final String bookingId;

  @override
  State<CancellationReasonBottomSheet> createState() =>
      _CancellationReasonBottomSheetState();
}

class _CancellationReasonBottomSheetState
    extends State<CancellationReasonBottomSheet> {
  final bookingsController = Get.put(CustomerBookingsController());
  int currentLength = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent full-screen expansion
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColor.blackColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          const TextWidget(
            text: "Cancel Service",
            fontWeight: FontWeight.w600,
            color: AppColor.blackColor,
            fontSize: 16,
          ),
          const SizedBox(
            height: 4,
          ),
          const TextWidget(
            text:
                "Please give us a reason for cancelling this service. This will help us improve our services.",
            fontWeight: FontWeight.w400,
            color: AppColor.blackColor,
            fontSize: 14,
          ),
          const SizedBox(
            height: 32,
          ),
          const TextWidget(
            text: "Leave a reason",
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 150,
            child: TextField(
              controller: bookingsController.reasonController,
              cursorHeight: 18,
              maxLines: 5,
              maxLength: 50, // Maximum character limit
              onChanged: (text) {
                setState(() {
                  currentLength = text.length; // Updates character count
                });
              },
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: false,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.primaryColor.shade300,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.primaryColor.shade300,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: "Leave a reason for service provider",
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          const SizedBox(
            height: 16,
          ),
          AppPrimaryButton(
            buttonText: "Submit",
            onPressed: () {
              Get.back();
              bookingsController.cancelBookingRequest(
                widget.bookingId,
                bookingsController.reasonController.text,
                context,
              );
            },
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

void showCancellationReasonBottomSheet(
  BuildContext context,
  String bookingId,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    backgroundColor: Colors.transparent, // Ensures rounded corners look good
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    builder: (BuildContext context) {
      return Wrap(
        children: [
          CancellationReasonBottomSheet(
            bookingId: bookingId,
          ),
        ],
      );
    },
  );
}
