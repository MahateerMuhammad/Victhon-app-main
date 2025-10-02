import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/widget/app_botton.dart';
import 'package:Victhon/widget/custom_form_field.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../utils/constants.dart';
import '../../../../widget/loader.dart';
import '../controller/profile_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final profileController = Get.put(ProfileController());
  File? _selectedImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance
// File? profileImage;

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        profileController.addCustomerProfileImage(imageFile: _selectedImage!);
        // profileImage = _selectedImage;
      });

      print("object ********* ${_selectedImage}");
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
                      hintText: "",
                    ),

                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // const TextWidget(
                    //   text: "Email",
                    //   fontWeight: FontWeight.w500,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // CustomFormField(
                    //   controller: profileController.emailController,
                    //   hintText: "Enter your email address",
                    //   validator: (value) => validateEmail(value ?? ''),
                    // ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // const TextWidget(
                    //   text: "Phone number",
                    //   fontWeight: FontWeight.w500,
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // CustomFormField(
                    //   controller: profileController.phoneNumberController,
                    //   hintText: "Enter your phone number",
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
                    // CountryDropDown(
                    //   values: country.value,
                    // ),

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

                    const SizedBox(height: 80),
                    AppPrimaryButton(
                      buttonText: "Save Changes",
                      onPressed: () {
                        print("-------- ${country.value}");
                        print("-------- ${state.value}");

                        profileController.editCustomerProfile(
                          profileController.nameController.text
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
