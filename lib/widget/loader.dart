import 'dart:ui';

import 'package:flutter/material.dart';
import '../../config/theme/app_color.dart';

class LoaderCircle extends StatelessWidget {
  const LoaderCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const SizedBox(),
          ),
        ),
        const Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              backgroundColor: AppColor.whiteColor,
              color: AppColor.primaryColor,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ],
    );
  }
}
