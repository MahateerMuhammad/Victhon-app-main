import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_color.dart';

class ManageServiceImagesContainer extends StatelessWidget {
  const ManageServiceImagesContainer({
    super.key,
    required this.selectedImage,
  });
  final String selectedImage;

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
        child: CachedNetworkImage(
          imageUrl: selectedImage,
          errorListener: (error) => const Icon(
            Icons.person,
            color: AppColor.whiteColor,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

