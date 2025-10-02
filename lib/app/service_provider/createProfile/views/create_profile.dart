import 'package:Victhon/app/service_provider/createProfile/views/profile_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/auth/widgets/country_dropdown.dart';
import 'package:Victhon/app/customerApp/auth/widgets/state_dropdown.dart';
import 'package:Victhon/app/service_provider/createProfile/controller/provider_create_profile_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/app_container.dart';
import 'package:Victhon/widget/custom_form_field.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../utils/functions.dart';
import '../../../../widget/loader.dart';
import 'selfie_capture_screen.dart';
import 'selfie_verification_screen.dart';

class ProviderCreateProfileScreen extends StatefulWidget {
  const ProviderCreateProfileScreen({
    super.key,
    required this.identifier,
  });
  final String identifier;

  @override
  State<ProviderCreateProfileScreen> createState() =>
      _ProviderCreateProfileScreenState();
}

class _ProviderCreateProfileScreenState
    extends State<ProviderCreateProfileScreen> {
  final createProfileController = Get.put(ProviderCreateProfileController());
  final formkey = GlobalKey<FormState>();
  bool containsUppercase = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: SafeArea(
            child: SingleChildScrollView(
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
                                color: index < 1
                                    ? AppColor.primaryColor
                                    : AppColor.primaryColor.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
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
                        controller: createProfileController.fullNameController,
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
                              controller:
                                  createProfileController.emailController,
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
                              controller:
                                  createProfileController.phoneNumberController,
                              hintText: "Enter your phone number",
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
                        height: 16,
                      ),
                      const TextWidget(
                        text: "Business Name",
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormField(
                        controller:
                            createProfileController.businessNameController,
                        hintText: "Enter your business name",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const TextWidget(
                        text: "NIN",
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomFormField(
                        controller: createProfileController.ninController,
                        hintText: "Enter your NIN",
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Obx(
                        () => AppPrimaryButton(
                          buttonText: "Done",
                          buttonColor:
                              createProfileController.isFormFilled.value
                                  ? AppColor.primaryColor
                                  : AppColor.primaryColor.shade200,
                          onPressed: createProfileController.isFormFilled.value
                              ? () {
                                  if (formkey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    createProfileController.identifier =
                                        widget.identifier;

                                    Get.to(() => const ProfileUploadScreen());
                                  }
                                }
                              : () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        createProfileController.isLoading.value
            ? const LoaderCircle()
            : const SizedBox(),
      ],
    );
  }
}
