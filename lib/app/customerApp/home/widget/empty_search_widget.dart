import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/textwidget.dart';

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({
    super.key,
    required this.searchInput,
  });
  final String searchInput;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 120,
        ),
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColor.primaryCardColor,
          child: Icon(
            Icons.search,
            size: 50,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextWidget(
          text: 'No result found for "$searchInput"',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 4,
        ),
        const TextWidget(
          text: "Check the spelling or try another search",
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
