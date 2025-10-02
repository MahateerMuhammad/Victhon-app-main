import 'package:flutter/material.dart';

import '../config/theme/app_color.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonWidth = double.infinity,
    this.imageString,
    this.borderColor = AppColor.grayColor,
    this.textColor = AppColor.blackColor,
  });
  final String buttonText;
  final Function() onPressed;
  final double buttonWidth;
  final String? imageString;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: 50,
      child: OutlinedButton(
        style: ButtonStyle(
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: borderColor),
          ),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageString == null ? const SizedBox() : Image.asset(imageString!),
            imageString == null
                ? const SizedBox()
                : const SizedBox(
                    width: 10,
                  ),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
