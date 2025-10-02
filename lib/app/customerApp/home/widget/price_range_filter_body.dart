import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';
import '../controller/home_controllers.dart';

class PriceRangeFilterBody extends StatefulWidget {
  const PriceRangeFilterBody({super.key});

  @override
  State<PriceRangeFilterBody> createState() => _PriceRangeFilterBodyState();
}

class _PriceRangeFilterBodyState extends State<PriceRangeFilterBody> {
  final homeController = Get.find<HomeControllers>();

  final List priceRangeList = [
    "Under 10,000",
    "10,000 - 50,000",
    "50,000 - 200,000",
    "200,000 - 500,000",
    "500,000 - Above"
  ];
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: priceRangeList.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (index == 0){
                      homeController.priceRangeFilter.value = {"minPrice": "1", "maxPrice": "10000"};
                    } else if(index == 1){
                      homeController.priceRangeFilter.value = {"minPrice": "10000", "maxPrice": "50000"};

                    }else if(index == 2){
                      homeController.priceRangeFilter.value = {"minPrice": "50000", "maxPrice": "200000"};

                    }else if(index == 1){
                      homeController.priceRangeFilter.value = {"minPrice": "200000", "maxPrice": "500000"};

                    }else if(index == 1){
                      homeController.priceRangeFilter.value = {"minPrice": "500000", "maxPrice": "1000000"};

                    }
                      selectedIndex = index;
                     setState(() {});
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
                        TextWidget(text: priceRangeList[index]),
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
        });
  }
}
