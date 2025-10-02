import 'package:flutter/material.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../config/theme/app_color.dart';

class TimeSetterContainer extends StatefulWidget {
  @override
  _TimeSetterContainerState createState() => _TimeSetterContainerState();
}

class _TimeSetterContainerState extends State<TimeSetterContainer> {
  TimeOfDay? selectedTime; // Stores selected time

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(), // Default to current time
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked; // Update the state with selected time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.whiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              selectedTime != null
                  ? TextWidget(
                      text: selectedTime!.format(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )
                  : const TextWidget(
                      text: "am/pm",
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
              
              const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Color.fromRGBO(0, 0, 0, 0.5),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
