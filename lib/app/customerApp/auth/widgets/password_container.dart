import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/textwidget.dart';

class PasswordContainer extends StatelessWidget {
  const PasswordContainer({
    super.key,
    required this.containerText,
    this.isActive = false,
  });
  final String containerText;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            width: 1,
            color: isActive == true
                ? AppColor.primaryColor
                : AppColor.inactiveColor,
          ),
          color:
              isActive == true ? AppColor.primaryColor : AppColor.whiteColor),
      child: TextWidget(
        text: containerText,
        color: isActive == true ? AppColor.whiteColor : AppColor.inactiveColor,
      ),
    );
  }
}
