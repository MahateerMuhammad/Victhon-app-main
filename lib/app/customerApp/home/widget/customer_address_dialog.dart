import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/widgets/country_dropdown.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/constants.dart';
import 'package:Victhon/widget/custom_form_field.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../auth/widgets/state_dropdown.dart';

class CustomerAddressDialogContent extends StatefulWidget {
  const CustomerAddressDialogContent({super.key});

  @override
  State<CustomerAddressDialogContent> createState() =>
      _CustomerAddressDialogContentState();
}

class _CustomerAddressDialogContentState
    extends State<CustomerAddressDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.whiteColor,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * 0.7, // Prevents overflow
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const TextWidget(
                      text: "Add Store Address",
                      fontWeight: FontWeight.w500,
                      color: AppColor.blackColor,
                      fontSize: 16,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColor.redColor1,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                const TextWidget(
                  text: "Country/Region",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 8,
                ),
                CountryDropDown(),
                const SizedBox(
                  height: 24,
                ),
                const TextWidget(
                  text: "State",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 8,
                ),
                StateDropdown(),
                const SizedBox(
                  height: 24,
                ),
                const TextWidget(
                  text: "City",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomFormField(
                  hintText: "City",
                  onChanged: (value) {
                    city.value = value;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                const TextWidget(
                  text: "Street Number and Name",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomFormField(
                  hintText: "12 Mine Street",
                  onChanged: (value) {
                    street.value = value;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        buttonText: "Cancel",
                        onPressed: () {
                          Get.back();
                        },
                        textColor: AppColor.primaryColor,
                        borderColor: AppColor.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: AppPrimaryButton(
                        buttonText: "Save",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showCustomerAddressDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: ClipRRect(
          borderRadius: BorderRadius.circular(20),

            child: const CustomerAddressDialogContent(),
          ),
        ),
      );
    },
  );
}
