import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/constants.dart';

import '../controller/auth_controller.dart';

// ignore: must_be_immutable
class StateDropdown extends StatefulWidget {
  StateDropdown({
    super.key,
    this.width = double.infinity,
  });
  final double width;

  @override
  State<StateDropdown> createState() => _StateDropdown();
}

class _StateDropdown extends State<StateDropdown> {
  String? values;
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
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
            "State",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: AppColor.inactiveColor,
            ),
          ),
          items: authController.stateDropDownItem.map(buildItem).toList(),
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Color.fromRGBO(0, 0, 0, 0.7),
            size: 30,
          ),
          onChanged: (value) {
            authController.updateSelectedState(value!);
            values = value;
            state.value = value;
            if (authController.selectedCountry.value == "Nigeria") {
              print("^^^^^^^^^^^ $value");

              // Find the map that matches the selected state
              final matchedState = nigeriaStateCitiesList.firstWhere(
                (item) => item["state"] == value,
              );
              print("^^^^^match^^^^^^ $matchedState");

              // Update citiesDropDownItem with the matched state's cities
              final cities = matchedState["cities"];
              print("^^^^^match^^^^^^ $cities");
              print("^^^^^match^^^^^^ ${cities is List}");

              if (cities is List) {
                authController.citiesDropDownItem.value =
                    List<String>.from(cities);
                authController.selectedCity.value =
                    authController.citiesDropDownItem[0];
                print("^^^^^cities^^^^^^ ${authController.citiesDropDownItem}");
              }
            }
            setState(() {});
          },
        ),
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
