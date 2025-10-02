import 'package:flutter/material.dart';
import '../../../../config/theme/app_color.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({
    super.key,
  });

  // final bool isLoading;
  // final Widget child;
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          backgroundColor: AppColor.inactivePrimaryColor,
          color: AppColor.primaryColor,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}
