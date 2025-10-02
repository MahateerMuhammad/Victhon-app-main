import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class ContactUsContainer extends StatelessWidget {
  const ContactUsContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 100,
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.primaryColor.shade50,
              child: icon,
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                TextWidget(
                  text: subtitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: subtitle));
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );

              },
              child: const Row(
                children: [
                  Icon(
                    Icons.copy,
                    color: AppColor.primaryColor,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  TextWidget(
                    text: "Copy",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
