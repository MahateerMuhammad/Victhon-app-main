import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';
import '../controller/home_controllers.dart';

class CategoryFilterBody extends StatefulWidget {
  const CategoryFilterBody({super.key});

  @override
  State<CategoryFilterBody> createState() => _CategoryFilterBodyState();
}

class _CategoryFilterBodyState extends State<CategoryFilterBody> {
  final homeController = Get.find<HomeControllers>();

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: homeController.categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      homeController.categoryFilter.value = homeController.categories[index]["categoryName"];
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: isSelected
                        ? const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: isSelected
                          ? BorderRadius.circular(5)
                          : BorderRadius.circular(0),
                      color: isSelected
                          ? AppColor.inactivePrimaryColor
                          : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(text: homeController.categories[index]["categoryName"]),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  color: AppColor.inactiveColor,
                ),
              ],
            ),
          );
        },);
  }
}