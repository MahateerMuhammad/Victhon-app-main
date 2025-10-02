import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/custom_form_field.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../../../customerApp/auth/controller/auth_controller.dart';
import '../controller/provider_create_profile_controller.dart';
import '../widget/bank_name_dialog.dart';

class AddBankDetails extends StatefulWidget {
  const AddBankDetails({super.key});

  @override
  State<AddBankDetails> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankDetails> {
  final createProfileController = Get.put(ProviderCreateProfileController());
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      // Progress bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          3,
                          (index) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 5,
                              decoration: BoxDecoration(
                                color: index < 2
                                    ? AppColor.primaryColor
                                    : AppColor.primaryColor.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const TextWidget(
                        text: 'Add Bank Account',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      const TextWidget(
                        text:
                            'Add your bank account details to receive payments.',
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Bank Name',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const BankNameTextfield(),
                      const SizedBox(height: 16),
                      const Text(
                        'Account Name',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomFormField(
                        controller:
                            createProfileController.accountNameController,
                        hintText: "Enter Account Name",
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Account Number',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomFormField(
                        controller:
                            createProfileController.accountNumberController,
                        hintText: "Enter Account Number",
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),

                      const SizedBox(height: 40),
                      AppPrimaryButton(
                        buttonText: "Save Bank Account",
                        buttonColor: createProfileController.isFormFilled.value
                            ? AppColor.primaryColor
                            : AppColor.primaryColor.shade200,
                        onPressed: createProfileController.isFormFilled.value
                            ? () {
                                createProfileController
                                    .createServiceProviderProfile(
                                  createProfileController
                                      .fullNameController.text,
                                  createProfileController.identifier.isEmail
                                      ? createProfileController.identifier
                                      : createProfileController
                                          .emailController.text,
                                  createProfileController.identifier.isEmail
                                      ? createProfileController
                                          .phoneNumberController.text
                                      : createProfileController.identifier,
                                  createProfileController
                                      .businessNameController.text,
                                  authController.selectedCountry.value,
                                  authController.selectedState.value,
                                  createProfileController.ninController.text,
                                  "serviceProvider",
                                  createProfileController.profileImageUrl.value,
                                );
                               
                              }
                            : () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          createProfileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
