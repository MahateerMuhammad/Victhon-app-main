import 'package:flutter/material.dart';

import '../../../config/theme/app_color.dart';

class ChatIconButton extends StatelessWidget {
  const ChatIconButton({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.onPressed,
    this.buttonWidth = double.infinity,
    this.buttonColor = AppColor.primaryCardColor,
    this.textColor = AppColor.whiteColor,
  });
  final String buttonText;
  final Function() onPressed;
  final double buttonWidth;
  final Color buttonColor;
  final Color textColor;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: ElevatedButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                buttonColor,
              ),
              elevation: WidgetStateProperty.all<double>(0),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            onPressed: onPressed,
            child: icon,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          buttonText,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
