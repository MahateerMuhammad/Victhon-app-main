import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/profile/controller/bank_account_controller.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/custom_form_field.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../../createProfile/controller/provider_create_profile_controller.dart';
import '../../createProfile/widget/bank_name_dialog.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({super.key});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  final bankAccountController = Get.put(BankAccountController());
  final createProfileController = Get.put(ProviderCreateProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: AppBar(
              title: const TextWidget(
                text: 'Add Bank Account',
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
                      'Account Number',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomFormField(
                      controller: bankAccountController.accountNumberController,
                      hintText: "Enter Account Number",
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Account Name',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomFormField(
                      controller: bankAccountController.accountNameController,
                      hintText: "Enter Account Name",
                    ),
                    const SizedBox(height: 40),
                    AppPrimaryButton(
                      buttonText: "Save Bank Account",
                      onPressed: () {
                        if (bankAccountController
                                .accountNameController.text.isEmpty ||
                            bankAccountController
                                .accountNumberController.text.isEmpty) {
                        } else {
                          bankAccountController.addBankAccount(
                            bankAccountController.accountNameController.text,
                            bankAccountController.accountNumberController.text,
                            createProfileController.selectedBank["name"],
                            false,
                            context,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          bankAccountController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
