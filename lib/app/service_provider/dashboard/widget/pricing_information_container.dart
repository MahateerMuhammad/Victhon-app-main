import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class PricingInformationContainer extends StatelessWidget {
  const PricingInformationContainer({
    super.key,
    required this.servicePrice,
    required this.flexiblePricing,
  });
  final String servicePrice;
  final String flexiblePricing;

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
                  text: "Service Price",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                const Spacer(),
                TextWidget(
                  text: servicePrice,
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
                  text: "Flexible Pricing",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                const Spacer(),
                TextWidget(
                  text: flexiblePricing,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
