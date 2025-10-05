import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../controller/service_provider_profile_controller.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final providerProfileController = Get.put(ServiceProviderProfileController());

  @override
  void initState() {
    super.initState();
    // Load preferences when screen initializes (only for service providers)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserRole();
    });
  }
  
  Future<void> _checkUserRole() async {
    try {
      // This will fail with 403 if user is not a service provider
      await providerProfileController.fetchNotifiPreference();
    } catch (e) {
      debugPrint("User is not a service provider, redirecting...");
      if (mounted) {
        Navigator.of(context).pop();
        Get.snackbar(
          "Access Denied",
          "This feature is only available for service providers",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
  
  // Create the list dynamically based on current controller values
  List<Map> get notificationList => [
    {
      "icon": Icons.date_range_outlined,
      "text": "Booking Requests",
      "select": providerProfileController.bookingRequests.value,
    },
    {
      "icon": CupertinoIcons.chat_bubble_text,
      "text": "New Messages",
      "select": providerProfileController.messages.value,
    },
    {
      "icon": Icons.payment_outlined,
      "text": "Payment Received",
      "select": providerProfileController.payments.value,
    },
    {
      "icon": Icons.star_border_outlined,
      "text": "Customer Reviews",
      "select": providerProfileController.customerReviews.value,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              title: const TextWidget(
                text: 'Notification Setting',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              centerTitle: true,
              backgroundColor: AppColor.whiteColor,
              surfaceTintColor: AppColor.whiteColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: 'Push Notifications',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.primaryCardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: notificationList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              notificationList[index]["icon"],
                              color: AppColor.primaryColor,
                            ),

                            title: Text(
                              notificationList[index]["text"],
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: SizedBox(
                              height: 35,
                              width: 45,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Switch(
                                  value: notificationList[index]["select"],
                                  activeColor: AppColor.whiteColor,
                                  activeTrackColor: AppColor.blueBorderColor,
                                  inactiveTrackColor:
                                      AppColor.primaryColor.shade100,
                                  inactiveThumbColor: AppColor.whiteColor,
                                  // Removing the focus/outline
                                  focusColor: Colors.transparent,
                                  trackOutlineColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  onChanged: (value) {
                                    // Update the controller values directly
                                    switch (index) {
                                      case 0: // Booking Requests
                                        providerProfileController.bookingRequests.value = value;
                                        break;
                                      case 1: // New Messages  
                                        providerProfileController.messages.value = value;
                                        break;
                                      case 2: // Payment Received
                                        providerProfileController.payments.value = value;
                                        break;
                                      case 3: // Customer Reviews
                                        providerProfileController.customerReviews.value = value;
                                        break;
                                    }

                                    // Call update with the new values
                                    providerProfileController
                                        .updateNotifiPreference(
                                      bookingRequestsValue:
                                          providerProfileController
                                              .bookingRequests.value,
                                      messagesValue: providerProfileController
                                          .messages.value,
                                      paymentsValue: providerProfileController
                                          .payments.value,
                                      customerReviewsValue:
                                          providerProfileController
                                              .customerReviews.value,
                                    );
                                  },
                                ),
                              ),
                            ),
                            onTap: () {
                              final currentValue = notificationList[index]["select"] as bool;
                              final newValue = !currentValue;
                              
                              // Update the controller values directly
                              switch (index) {
                                case 0: // Booking Requests
                                  providerProfileController.bookingRequests.value = newValue;
                                  break;
                                case 1: // New Messages  
                                  providerProfileController.messages.value = newValue;
                                  break;
                                case 2: // Payment Received
                                  providerProfileController.payments.value = newValue;
                                  break;
                                case 3: // Customer Reviews
                                  providerProfileController.customerReviews.value = newValue;
                                  break;
                              }

                              // Call update with the new values
                              providerProfileController.updateNotifiPreference(
                                bookingRequestsValue: providerProfileController.bookingRequests.value,
                                messagesValue: providerProfileController.messages.value,
                                paymentsValue: providerProfileController.payments.value,
                                customerReviewsValue: providerProfileController.customerReviews.value,
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          providerProfileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
