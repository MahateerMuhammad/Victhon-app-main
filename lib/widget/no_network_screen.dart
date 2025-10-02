import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/textwidget.dart';

class NoNetworkWidget extends StatelessWidget {
  const NoNetworkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
        ),
        Icon(
          Icons.wifi_off_outlined,
          size: 60,
          color: AppColor.redColor1,
        ),
        SizedBox(
          height: 16,
        ),
        TextWidget(
          text: 'No Internet Connection',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          height: 4,
        ),
        TextWidget(
          text: "Check you network connection and try again",
          fontSize: 16,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
        // AppPrimaryButton(
        //   buttonText: "Add/Manage Service",
        //   onPressed: () {

        //   },
        // ),
      ],
    );
  }
}
