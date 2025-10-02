import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';

import '../../../../widget/textwidget.dart';

class LocationInformationContainer extends StatelessWidget {
  const LocationInformationContainer({
    super.key,
    required this.remoteService,
    required this.onsiteService,
    required this.inStoreService,
    required this.inStoreAddress,
  });
  final String remoteService;
  final String onsiteService;
  final String inStoreService;
  final String inStoreAddress;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.primaryCardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const TextWidget(
                  text: "Remote (Online Services)",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                const Spacer(),
                TextWidget(
                  text: remoteService,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const TextWidget(
                  text: "Onsite (Customer Location)",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                const Spacer(),
                TextWidget(
                  text: onsiteService,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const TextWidget(
                  text: "In-Store (Your Address)",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                const Spacer(),
                TextWidget(
                  text: inStoreService,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const TextWidget(
              text: "In-Store Address",
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            const SizedBox(
              height: 8,
            ),
            TextWidget(
              text: inStoreAddress,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
