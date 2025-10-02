import 'package:flutter/material.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/textwidget.dart';

class NoMessagesView extends StatelessWidget {
  final String userType;
  const NoMessagesView({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppIcons.noChat,
              scale: 4,
            ),
            const SizedBox(
              height: 10,
            ),
            const TextWidget(
              text: "No Messages",
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 4,
            ),
            TextWidget(
              text: "Your conversation with $userType will appear here. ",
              fontSize: 16,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
