import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Victhon/app/service_provider/profile/controller/service_provider_profile_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/custom_form_field.dart';
import 'package:Victhon/widget/textwidget.dart';
import '../../../../widget/loader.dart';

class ServiceProviderEditProfile extends StatefulWidget {
  const ServiceProviderEditProfile({super.key});

  @override
  State<ServiceProviderEditProfile> createState() =>
      _ServiceProviderEditProfileState();
}

class _ServiceProviderEditProfileState
    extends State<ServiceProviderEditProfile> {
  final profileController = Get.put(ServiceProviderProfileController());
  File? _selectedImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance
// File? profileImage;

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        profileController.addProviderProfileImage(imageFile: _selectedImage!);
        // profileImage = _selectedImage;
      });

      debugPrint("object ********* $_selectedImage");
    }
  }

  bool availabilityStatus = false;
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
              centerTitle: true,
              title: const TextWidget(
                text: "Edit Profile",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Profile Image
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: CachedNetworkImageProvider(
                          profileController.profileImageUrl.value,
                          errorListener: (error) => const Icon(
                            Icons.person,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: const Center(
                        child: TextWidget(
                          text: "Edit",
                          fontSize: 16,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Name and Email

                    const TextWidget(
                      text: "Full Name",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 8),

                    CustomFormField(
                      controller: profileController.nameController,
                      hintText: profileController.profileDetails["fullName"],
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    // const TextWidget(
                    //   text: "Email",
                    //   fontWeight: FontWeight.w500,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // CustomFormField(
                    //   controller: profileController.emailController,
                    //   hintText: profileController.profileDetails["email"],
                    //   validator: (value) => validateEmail(value ?? ''),
                    // ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // const TextWidget(
                    //   text: "Phone Number",
                    //   fontWeight: FontWeight.w500,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // CustomFormField(
                    //   controller: profileController.phoneNumberController,
                    //   hintText: profileController.profileDetails["phone"],
                    // ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // const TextWidget(
                    //   text: "Country",
                    //   fontWeight: FontWeight.w500,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // CountryDropDown(),

                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // const TextWidget(
                    //   text: "State",
                    //   fontWeight: FontWeight.w500,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // StateDropdown(),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    const TextWidget(
                      text: "Business Name",
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomFormField(
                      controller: profileController.businessNameController,
                      hintText: '',
                    ),

                    const SizedBox(height: 80),
                    AppPrimaryButton(
                      buttonText: "Save Changes",
                      onPressed: () {
                        profileController.editProviderProfile(
                          profileController.nameController.text,
                          profileController.businessNameController.text,

                          // profileController.emailController.text,
                          // profileController.phoneNumberController.text,
                          // country.value,
                          // state.value,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          profileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox()
        ],
      ),
    );
  }
}
