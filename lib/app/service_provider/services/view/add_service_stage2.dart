import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/services/controller/service_money_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/dashboard/widget/row_radio_button.dart';
import 'package:Victhon/widget/app_textfield.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../widget/app_botton.dart';
import '../../../../widget/app_outline_button.dart';
import '../controller/services_controller.dart';
import 'add_service_stage3.dart';

class AddServiceStage2 extends StatefulWidget {
  const AddServiceStage2({super.key});

  @override
  State<AddServiceStage2> createState() => _AddServiceStage2State();
}

class _AddServiceStage2State extends State<AddServiceStage2> {
  final servicesController = Get.put(ServicesController());
  final moneyController = Get.put(ServiceMoneyController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: const TextWidget(
            text: "Add Service",
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
                SizedBox(
                  height: 5,
                  child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 4,
                          ),
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width / 4.5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: index == 0 || index == 1
                                ? AppColor.primaryColor
                                : AppColor.primaryColor.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 24,
                ),
                const TextWidget(
                  text: "Set Your Pricing",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 4,
                ),
                const TextWidget(
                  text: "Tell customers what they’ll pay for your service.",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 24,
                ),
                const TextWidget(
                  text: "Service Price",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 8,
                ),
                AppTextfield(
                  hintText: "Enter your service price",
                  controller: moneyController.servicePricecontroller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    moneyController.onValueChanged(
                        moneyController.servicePricecontroller, value);
                    setState(() {});
                  },
                ),
                const TextWidget(
                  text: "Enter the fixed amount you charge for this service",
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const TextWidget(
                      text: "Flexible Pricing",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 35,
                      width: 45,
                      child: Obx(
                        () => FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: servicesController.isFlexiblePricing.value,
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
                                servicesController.isFlexiblePricing.value =
                                    value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const RadioButtonRow(),
                const SizedBox(
                  height: 8,
                ),
                servicesController.pricingType.value == "Hourly Rate"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextWidget(
                            text: "Hourly Rate",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppTextfield(
                            hintText: "Enter price per service (N)",
                            controller: moneyController.hourlyRateController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => moneyController.onValueChanged(
                                moneyController.hourlyRateController, value),
                          ),
                          const Wrap(
                            children: [
                              TextWidget(
                                text:
                                    "Enter the amount you charge per hour. For example,",
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                              TextWidget(
                                text: "₦1000/hour",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColor.primaryColor,
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        buttonText: "Back",
                        onPressed: () {
                          Get.back();
                        },
                        buttonWidth: MediaQuery.of(context).size.width / 2 - 24,
                        textColor: AppColor.primaryColor,
                        borderColor: AppColor.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16,),

                    Expanded(
                      child: AppPrimaryButton(
                        buttonText: "Next",
                        buttonColor:
                            moneyController.servicePricecontroller.text.isNotEmpty
                                ? AppColor.primaryColor
                                : AppColor.primaryColor.shade200,
                        onPressed: moneyController
                                .servicePricecontroller.text.isNotEmpty
                            ? () {
                                servicesController.servicePriceAmount.value =
                                    moneyController.parseMoneyToInt(moneyController
                                        .servicePricecontroller.text);
                                if (moneyController
                                    .hourlyRateController.text.isNotEmpty) {
                                  servicesController.hourlyRateAmount.value =
                                      moneyController.parseMoneyToInt(
                                          moneyController
                                              .hourlyRateController.text);
                                  print(
                                      "------------- ${servicesController.hourlyRateAmount}");
                                }
                            
                                print(
                                    "------------- ${servicesController.servicePriceAmount}");
                            
                                Get.to(() => const AddServiceStage3());
                              }
                            : () {},
                        buttonWidth: MediaQuery.of(context).size.width / 2 - 24,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
