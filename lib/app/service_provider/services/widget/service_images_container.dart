import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../config/theme/app_color.dart';

class ServiceImagesContainer extends StatelessWidget {
  const ServiceImagesContainer({
    super.key,
    required this.selectedImage,
  });
  final File selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      width: MediaQuery.of(context).size.width / 3.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColor.primaryColor.shade50,
      ),
      child: ClipRRect(
        // Display the selected image
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          selectedImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
