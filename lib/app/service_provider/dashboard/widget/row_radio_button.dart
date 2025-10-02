import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/controller/services_controller.dart';

class RadioButtonRow extends StatefulWidget {
  const RadioButtonRow({super.key});

  @override
  State<RadioButtonRow> createState() => _RadioButtonRowState();
}

class _RadioButtonRowState extends State<RadioButtonRow> {
  final servicesController = Get.put(ServicesController());
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              value: "Hourly Rate",
              groupValue: servicesController.pricingType.value,
              onChanged: (value) {
                setState(() {
                  servicesController.pricingType.value = value!;
                });
              },
            ),
            const Text("Hourly Rate"),
          ],
        ),
        const SizedBox(width: 20), // Space between radio buttons
        Row(
          children: [
            Radio<String>(
              value: "Custom Package",
              groupValue: servicesController.pricingType.value,
              onChanged: (value) {
                setState(() {
                  servicesController.pricingType.value = value!;
                });
              },
            ),
            const Text("Custom Package"),
          ],
        ),
      ],
    );
  }
}
