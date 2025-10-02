import 'package:flutter/material.dart';

import '../../../../utils/icons.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/textwidget.dart';

class BankAccountEmpty extends StatelessWidget {
  const BankAccountEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppIcons.bankIcon,
              scale: 4,
            ),
            const SizedBox(
              height: 10,
            ),
            const TextWidget(
              text: 'No Bank Account',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 4,
            ),
            const TextWidget(
              text: 'Add a bank account for withdrawing your earnings.',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            AppPrimaryButton(
              buttonText: "Add Bank Account",
              onPressed: () {},
            )
          ],
        ),
      );
  }
}