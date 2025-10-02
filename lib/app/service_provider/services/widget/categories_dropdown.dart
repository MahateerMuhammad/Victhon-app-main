import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';

import '../controller/services_controller.dart';

// ignore: must_be_immutable
class CategoriesDropdown extends StatefulWidget {
  CategoriesDropdown({
    super.key,
    this.width = double.infinity,
    this.dropdownType = "Type",
  });
  final double width;
  final String dropdownType;

  @override
  State<CategoriesDropdown> createState() => _CategoriesDropdown();
}

class _CategoriesDropdown extends State<CategoriesDropdown> {
  final servicesController = Get.put(ServicesController());

  String? values;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 5, 3),
        width: widget.width,
        height: 48,
        decoration: BoxDecoration(
          color: AppColor.primaryCardColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButton<String>(
          dropdownColor: AppColor.whiteColor,
          isExpanded: true,
          value: values,
          underline: const SizedBox(),
          focusColor: Colors.transparent,
          hint: const Text(
            "Category",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          items: servicesController.categories.isEmpty
              ? []
              : servicesController.categories
                  .map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value:
                        category["categoryName"], // Extract the category name
                    child: Text(category["categoryName"] ?? "Unknown"),
                  );
                }).toList(),
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Color.fromRGBO(0, 0, 0, 0.5),
            size: 30,
          ),
          onChanged: (value) {
            setState(() {
              values = value;
              servicesController.serviceCategory.value = value!;

              // Find the selected category and save its _id
              var selectedCategory = servicesController.categories.firstWhere(
                (category) => category["categoryName"] == value,
                orElse: () => null,
              );

              if (selectedCategory != null) {
                String selectedCategoryId = selectedCategory["_id"];
                servicesController.serviceCategoryId.value = selectedCategoryId;
                print("Selected Category ID: $selectedCategoryId");

                // You can now save selectedCategoryId wherever needed
              }
            });
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
            fontSize: 14,
            color: AppColor.blackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
