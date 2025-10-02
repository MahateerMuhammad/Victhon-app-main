import 'package:flutter/material.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/textwidget.dart';

class CustomerNotificationOffView extends StatelessWidget {
  const CustomerNotificationOffView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppIcons.notificationOff,
            scale: 4,
          ),
          const SizedBox(
            height: 10,
          ),
          const TextWidget(
            text: "No Notifications",
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 4,
          ),
          const TextWidget(
            text:
                "You're all caught up! When there are updates about your bookings, payments, or account, you'll see them here.",
            fontSize: 16,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w400,
          ),
          const SizedBox(
            height: 10,
          ),
          // AppPrimaryButton(
          //   buttonText: "Enable Notification",
          //   onPressed: () {},
          // )
        ],
      ),
    );
  }
}
