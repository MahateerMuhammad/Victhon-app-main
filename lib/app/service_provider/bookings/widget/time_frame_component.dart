import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../../../widget/textwidget.dart';

class TimeFrameComponent extends StatefulWidget {
  const TimeFrameComponent({super.key});

  @override
  State<TimeFrameComponent> createState() => _TimeFrameComponentState();
}

class _TimeFrameComponentState extends State<TimeFrameComponent> {
  String selectedTimeFrame = 'Today';
  DateTime? pickedStartDate = DateTime.now();
  DateTime? pickedEndDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ["Today", "This Week", "Custom"]
              .map(
                (label) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedTimeFrame = label;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColor.primaryCardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: selectedTimeFrame == label
                                    ? AppColor.primaryColor
                                    : Colors.transparent),
                          ),
                          child: Center(
                            child: TextWidget(
                              text: label,
                              fontSize: 14,
                              fontWeight: selectedTimeFrame == label
                                  ? FontWeight.w500
                                  : FontWeight.w200,
                            ),
                          ),
                        ),
                      )
                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.grey[200],
                      //     foregroundColor: Colors.black,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      //   child: Text(label),
                      // ),
                      ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),

        // Start Date & End Date Selection
        _buildDateSelector(
          context,
        ),

        const SizedBox(height: 24),

        // Buttons: Reset & Apply
        Row(
          children: [
            Expanded(
              child: AppOutlinedButton(
                buttonText: "Reset Filter",
                borderColor: AppColor.primaryColor,
                textColor: AppColor.primaryColor,
                onPressed: () {
                  setState(() {
                    selectedTimeFrame = "Today";
                    pickedStartDate = DateTime.now();
                    pickedEndDate = DateTime.now();
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppPrimaryButton(
                buttonText: "Apply",
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              pickedStartDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              setState(() {
                pickedStartDate = pickedStartDate;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start Date",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    pickedStartDate == null
                        ? ''
                        : "${pickedStartDate!.day}-${pickedStartDate!.month}-${pickedStartDate!.year}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Icon(
                    Icons.date_range_outlined,
                    color: AppColor.primaryColor.shade100,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: AppColor.primaryColor.shade50,
            height: 1,
          ),
          InkWell(
            onTap: () async {
              pickedEndDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              setState(() {
                pickedEndDate = pickedEndDate;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "End Date",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    pickedEndDate == null
                        ? ''
                        : "${pickedEndDate!.day}-${pickedEndDate!.month}-${pickedEndDate!.year}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Icon(
                    Icons.date_range_outlined,
                    color: AppColor.primaryColor.shade100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
