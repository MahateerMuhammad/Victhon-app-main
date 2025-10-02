import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/dashboard/widget/weekly_schedule_container.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../../services/view/review_services.dart';

class SetAvailability extends StatefulWidget {
  const SetAvailability({super.key, required this.availabilityHeader,});
  final String availabilityHeader;

  @override
  State<SetAvailability> createState() => _SetAvailabilityState();
}

class _SetAvailabilityState extends State<SetAvailability> {
  bool availabilityStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const TextWidget(
          text: "Set Availability",
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColor.whiteColor,
        surfaceTintColor: AppColor.whiteColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: "Set Your Service Availability",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 4,
              ),
              const TextWidget(
                text:
                    "Let clients know when you're available to render services.",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        text: "Availability Status",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      const TextWidget(
                        text: "Turn this on to set your weekly schedule.",
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  ),
                  const Spacer(),
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
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              availabilityStatus
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: "Weekly Schedule",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        WeeklyScheduleContainer(weekDay: "SUNDAYs"),
                        SizedBox(
                          height: 24,
                        ),
                        WeeklyScheduleContainer(weekDay: "MONDAYs"),
                        SizedBox(
                          height: 24,
                        ),
                        WeeklyScheduleContainer(weekDay: "TUESDAYs"),
                        SizedBox(
                          height: 24,
                        ),
                        WeeklyScheduleContainer(weekDay: "WEDNESDAYs"),
                        SizedBox(
                          height: 24,
                        ),
                        WeeklyScheduleContainer(weekDay: "THURSDAYs"),
                        SizedBox(
                          height: 24,
                        ),
                        WeeklyScheduleContainer(weekDay: "FRIDAYs"),
                        SizedBox(
                          height: 24,
                        ),
                        WeeklyScheduleContainer(weekDay: "SATURDAYs"),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.backgroundYellow),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: TextWidget(
                          text:
                              """Your availability is currently turned off. Clients won’t be able to book your services until you turn it on.""",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 40,
              ),
              availabilityStatus
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppOutlinedButton(
                          buttonText: "Cancel",
                          onPressed: () {
                            Get.back();
                          },
                          buttonWidth: MediaQuery.of(context).size.width / 2 - 24,
                          textColor: AppColor.primaryColor,
                          borderColor: AppColor.primaryColor,
                        ),
                        AppPrimaryButton(
                          buttonText: "Save Settings",
                          onPressed: () {
                            Get.back();
                            Get.to(() => ReviewServices());
                          },
                          buttonWidth: MediaQuery.of(context).size.width / 2 - 24,
                        )
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
