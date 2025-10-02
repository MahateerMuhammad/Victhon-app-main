import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';

import '../../../../widget/textwidget.dart';

class ServiceInformationContainer extends StatelessWidget {
  const ServiceInformationContainer({
    super.key,
    required this.serviceName,
    required this.category,
    required this.description,
  });
  final String serviceName;
  final String category;
  final String description;

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
                  text: "Service Name",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                const Spacer(),
                TextWidget(
                  text: serviceName,
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
                  text: "Category",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                const Spacer(),
                TextWidget(
                  text: category,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const TextWidget(
              text: "Description",
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            const SizedBox(
              height: 8,
            ),
            TextWidget(
              text: description,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
