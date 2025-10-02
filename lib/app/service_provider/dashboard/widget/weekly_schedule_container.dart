import 'package:flutter/material.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/dashboard/widget/date_dropdown.dart';

import '../../../../widget/textwidget.dart';

class WeeklyScheduleContainer extends StatefulWidget {
  const WeeklyScheduleContainer({
    super.key,
    required this.weekDay,
  });
  final String weekDay;

  @override
  State<WeeklyScheduleContainer> createState() =>
      _WeeklyScheduleContainerState();
}

class _WeeklyScheduleContainerState extends State<WeeklyScheduleContainer> {
  bool availabilityStatus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.primaryCardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                TextWidget(
                  text: widget.weekDay,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                Row(
                  children: [
                    TextWidget(
                      text: availabilityStatus ? "Available" : "Unavailable",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      height: 35,
                      width: 45,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                            value: availabilityStatus,
                            activeColor: AppColor.whiteColor,
                            activeTrackColor: AppColor.blueBorderColor,
                            inactiveTrackColor: AppColor.primaryColor.shade100,
                            inactiveThumbColor: AppColor.whiteColor,
                            // Removing the focus/outline
                            focusColor: Colors.transparent,
                            trackOutlineColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onChanged: (value) {
                              setState(() {
                                availabilityStatus = value;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            availabilityStatus
                ? const SizedBox(
                    height: 16,
                  )
                : const SizedBox(),
            availabilityStatus
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            text: "Start Time",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TimeSetterContainer(),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            text: "End Time",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TimeSetterContainer(),
                        ],
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
