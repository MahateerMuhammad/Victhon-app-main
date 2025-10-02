import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/bookings/controller/bookings_controller.dart';

class RatingWidget extends StatelessWidget {
  final ratingController = Get.put(CustomerBookingsController());

  RatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return IconButton(
            icon: Icon(
              Icons.star,
              size: 40,
              color: index < ratingController.rating.value
                  ? Colors.amber
                  : Colors.grey.shade400,
            ),
            onPressed: () {
              ratingController.setRating(index + 1);
            },
          );
        }),
      );
    });
  }
}
