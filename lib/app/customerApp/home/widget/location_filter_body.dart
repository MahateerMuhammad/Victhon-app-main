import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';
import '../controller/home_controllers.dart';

class LocationFilterBody extends StatefulWidget {
  const LocationFilterBody({super.key});

  @override
  State<LocationFilterBody> createState() => _LocationFilterBodyState();
}

class _LocationFilterBodyState extends State<LocationFilterBody> {
  final homeController = Get.find<HomeControllers>();

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: homeController.stateDropDownItem.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    homeController.locationFilter.value =
                        homeController.stateDropDownItem[index];
                    selectedIndex = index;
                  });
                },
                child: Container(
                  padding: isSelected
                      ? const EdgeInsets.symmetric(horizontal: 8, vertical: 10)
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
                      TextWidget(text: homeController.stateDropDownItem[index]),
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
      },
    );
  }
}
