import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/main.dart';

import '../../../../utils/constants.dart';
import '../controller/auth_controller.dart';

// ignore: must_be_immutable
class CountryDropDown extends StatefulWidget {
  CountryDropDown({
    super.key,
    // this.values,
    this.width = double.infinity,
    // required this.dropdownType,
  });
  final double width;
  // String? values;

  // final String dropdownType;

  @override
  State<CountryDropDown> createState() => _CountryDropDown();
}

class _CountryDropDown extends State<CountryDropDown> {
  String? values;
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 2, 5, 3),
      width: widget.width,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.inactiveColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: values,
        dropdownColor: AppColor.whiteColor,
        underline: const SizedBox(),
        focusColor: Colors.transparent,
        hint: const Text(
          "Country",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            color: AppColor.inactiveColor,
          ),
        ),
        items: countryList.map(buildItem).toList(),
        icon: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Color.fromRGBO(0, 0, 0, 0.7),
          size: 30,
        ),
        onChanged: (value) {
          values = value;
          authController.updateSelectedCountry(value!);
          box.write("Country", value);
          country.value = value;
          // void setStateSelection() {
          if (authController.selectedCountry.value == "Nigeria") {
            authController.stateDropDownItem.value = nigeriaStateCitiesList
                .map<String>((item) => item["state"] as String)
                .toList();
            authController.selectedState.value =
                authController.stateDropDownItem[0];
            print("-------------- ${authController.stateDropDownItem}");
          } else if (authController.selectedCountry.value == "Germany") {
            authController.stateDropDownItem.value = germanyStatesCitiesList
                .map<String>((item) => item["state"] as String)
                .toList();
            authController.selectedState.value =
                authController.stateDropDownItem[0];
            print("-------------- ${authController.stateDropDownItem}");
          } else if (authController.selectedCountry.value == "Canada") {
            authController.stateDropDownItem.value = canadaStateCitiesList
                .map<String>((item) => item["state"] as String)
                .toList();
            authController.selectedState.value =
                authController.stateDropDownItem[0];
          } else if (authController.selectedCountry.value == "United States") {
            authController.stateDropDownItem.value = usStateCitiesList
                .map<String>((item) => item["state"] as String)
                .toList();
            authController.selectedState.value =
                authController.stateDropDownItem[0];
          } else if (authController.selectedCountry.value == "United Kingdom") {
            authController.stateDropDownItem.value = ukStatesCitiesList
                .map<String>((item) => item["state"] as String)
                .toList();
            authController.selectedState.value =
                authController.stateDropDownItem[0];

            // }
            // You can add more conditions for other countries here
          }

          setState(() {});
        },
      ),
    );
  }

  DropdownMenuItem<String> buildItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: FittedBox(
        child: Text(
          item,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 16,
            color: AppColor.blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
