import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/controller/auth_controller.dart';
import 'package:Victhon/app/customerApp/auth/widgets/country_dropdown.dart';
import 'package:Victhon/app/customerApp/auth/widgets/state_dropdown.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/icons.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_container.dart';
import 'package:Victhon/widget/custom_form_field.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../utils/functions.dart';
import '../../../../widget/loader.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({
    super.key,
    required this.identifier,
  });
  final String identifier;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final authController = Get.put(AuthController());
  final formkey = GlobalKey<FormState>();
  bool containsUppercase = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back),
                        ),
                        const Spacer(),
                        Image.asset(
                          AppIcons.victhonLogo,
                          scale: 10,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TextWidget(
                      text: "Create your profile",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // TextWidget(text: text)
                    const SizedBox(
                      height: 20,
                    ),
                    const TextWidget(
                      text: "Full Name",
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomFormField(
                      controller: authController.fullNameController,
                      hintText: "Enter your full name",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const TextWidget(
                      text: "Email",
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    widget.identifier.isEmail
                        ? AppContainer(text: widget.identifier)
                        : CustomFormField(
                            controller: authController.emailController,
                            hintText: "Enter your email address",
                            validator: (value) => validateEmail(value ?? ''),
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    const TextWidget(
                      text: "Phone number",
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    widget.identifier.isEmail
                        ? CustomFormField(
                            controller: authController.phoneNumberController,
                            hintText: "Enter your phone number ",
                            validator: (value) => value!.isPhoneNumber
                                ? null
                                : "Enter a validate phone number",
                            keyboardType: TextInputType.phone,
                            maxLength: 15,
                          )
                        : AppContainer(text: widget.identifier),
                    const SizedBox(
                      height: 16,
                    ),
                    const TextWidget(
                      text: "Country",
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CountryDropDown(),

                    const SizedBox(
                      height: 16,
                    ),
                    const TextWidget(
                      text: "State",
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    StateDropdown(),

                    const SizedBox(
                      height: 40,
                    ),
                    Obx(
                      () => AppPrimaryButton(
                        buttonText: "Done",
                        buttonColor: authController.isFormFilled.value
                            ? AppColor.primaryColor
                            : AppColor.primaryColor.shade200,
                        onPressed: authController.isFormFilled.value
                            ? () {
                                if (formkey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  authController.createCustomerProfile(
                                    authController.fullNameController.text,
                                    widget.identifier.isEmail
                                        ? widget.identifier
                                        : authController.emailController.text,
                                    widget.identifier.isEmail
                                        ? authController
                                            .phoneNumberController.text
                                        : widget.identifier,
                                    authController.selectedCountry.value,
                                    authController.selectedState.value,
                                    "customer",
                                  );
                                }
                              }
                            : () {
                              print(widget.identifier.isEmail);
                            },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        authController.isLoading.value
            ? const LoaderCircle()
            : const SizedBox(),
      ],
    );
  }
}
