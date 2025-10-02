import 'package:flutter/material.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/textwidget.dart';

class EmptyBookingsState extends StatelessWidget {
  const EmptyBookingsState({
    super.key,
    this.status = '',
  });
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          TextWidget(
            text: status!.isEmpty ? "No Bookings Yet" : "No $status Bookings",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(
            height: 4,
          ),
          TextWidget(
            text: status!.isEmpty
                ? "You haven't received any booking requests.\nAdd/Manage your service to attract customers."
                : "You have no $status deliveries.",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          // AppPrimaryButton(
          //   buttonText: "Add/Manage Service",
          //   onPressed: () {

          //   },
          // ),
        ],
      ),
    );
  }
}
