import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/home/controller/home_controllers.dart';
import 'package:Victhon/app/customerApp/home/widget/customer_address_dialog.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/constants.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../utils/functions.dart';
import '../../../../widget/custom_snackbar.dart';
import '../../../../widget/loader.dart';

class RequestServiceScreen extends StatefulWidget {
  RequestServiceScreen({
    super.key,
    required this.serviceDetails,
  });
  final Map<String, dynamic> serviceDetails;

  @override
  State<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends State<RequestServiceScreen> {
  final homeController = Get.put(HomeControllers());

  String paymentOption = "Card";

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              backgroundColor: AppColor.whiteColor,
              elevation: 0,
              surfaceTintColor: AppColor.whiteColor,
              title: const TextWidget(
                text: "Request Service",
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Your current address",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Obx(
                                    () => TextWidget(
                                      text: "$street, $city, $state, $country",
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showCustomerAddressDialog(context);
                              // Edit address logic
                            },
                            child: Column(
                              children: [
                                const Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.yellowColor1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  width: 25,
                                  height: 1,
                                  color: AppColor.yellowColor1,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Choose how to pay",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          TextWidget(
                            text: formatAsMoney(double.parse(widget
                                .serviceDetails["servicePrice"]
                                .toString())),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      PaymentOption(
                        icon: Icons.credit_card,
                        title: "Pay through the app",
                        isSelected: paymentOption == "Card",
                        onTap: () {
                          // Handle card selection
                          paymentOption = "Card";
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 12),

                      PaymentOption(
                        icon: Icons.money,
                        title: "Cash on delivery (Pay to the provider)",
                        isSelected: paymentOption == "Cash",
                        onTap: () {
                          // Handle cash selection
                          paymentOption = "Cash";
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      TextWidget(
                        text:
                            "Message ${widget.serviceDetails["providerId"]["fullName"]}",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Share what you require as part of your service request.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: homeController.messageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                              "Hi ${widget.serviceDetails["providerId"]["fullName"]}, I have such special needs...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Obx(
                        () => AppPrimaryButton(
                          buttonText: "Make Request",
                          buttonColor:
                              homeController.isFormFilled.value == false
                                  ? AppColor.primaryColor.shade200
                                  : AppColor.primaryColor,
                          onPressed: homeController.isFormFilled.value == false
                              ? () {}
                              : () {
                                  if (formkey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    if (state.isEmpty ||
                                        city.isEmpty ||
                                        street.isEmpty ||
                                        country.isEmpty) {
                                      customSnackbar(
                                        "ERROR".tr,
                                        "Please enter your full address",
                                        AppColor.primaryColor.shade700,
                                      );
                                    }
                                    homeController.bookService(
                                      widget.serviceDetails["_id"],
                                      paymentOption,
                                      homeController.messageController.text,
                                      street.value,
                                      city.value,
                                      state.value,
                                      country.value,
                                      context,
                                    );
                                  }
                                },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // AppOutlinedButton(buttonText: "Cancel Request", onPressed: (){},)
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          homeController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox(),
        ],
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColor.primaryColor : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColor.primaryColor : Colors.grey,
              ),
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: AppColor.primaryColor,
            ),
        ],
      ),
    );
  }
}
