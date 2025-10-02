import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Victhon/widget/app_botton.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/app_outline_button.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../../../../widget/custom_snackbar.dart';
import '../controller/provider_create_profile_controller.dart';

class ProfileUploadScreen extends StatefulWidget {
  const ProfileUploadScreen({super.key});

  @override
  State<ProfileUploadScreen> createState() => _ProfileUploadScreenState();
}

class _ProfileUploadScreenState extends State<ProfileUploadScreen> {
  final createProfileController = Get.put(ProviderCreateProfileController());
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.whiteColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              child: Column(
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
                  const SizedBox(height: 40),
                  _image == null
                      ? Center(
                          child: CircleAvatar(
                            radius: 150,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        )
                      : Center(
                          child: CircleAvatar(
                            radius: 150,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: FileImage(_image!),
                          ),
                        ),
                  const SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () => _pickMedia(),
                    child: const TextWidget(
                      text: "Select Image",
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  AppPrimaryButton(
                    buttonText: "Use This Photo",
                    buttonColor: _image == null
                        ? AppColor.primaryColor.shade200
                        : AppColor.primaryColor,
                    onPressed: _image == null
                        ? () {}
                        : () {
                            createProfileController.addProviderProfileImage(
                                imageFile: _image!, context: context);
                          },
                  )
                ],
              ),
            ),
          ),
          createProfileController.isLoading.value
              ? const LoaderCircle()
              : const SizedBox(),
        ],
      ),
    );
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back),
                ),
                const SizedBox(
                  height: 16,
                ),
                const TextWidget(
                  text: "Profile Image",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                const TextWidget(
                  text: "Upload profile Image",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 32,
                ),
                AppPrimaryButton(
                  buttonText: "Camera",
                  onPressed: () async {
                    Navigator.pop(context);
                    await _pickImageFromSource(ImageSource.camera);
                  },
                  buttonColor: AppColor.primaryColor,
                  textColor: AppColor.whiteColor,
                ),
                const SizedBox(height: 16),
                AppOutlinedButton(
                  buttonText: "Album",
                  onPressed: () async {
                    Navigator.pop(context);
                    await _pickImageFromSource(ImageSource.gallery);
                  },
                  textColor: AppColor.primaryColor,
                  borderColor: AppColor.primaryColor,
                ),
              ],
            ),
          );
        });
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85, // Compress image to reduce file size
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);

        // Validate file exists
        if (await file.exists()) {
          // Check file size (5MB limit)
          final fileSize = await file.length();
          if (fileSize > 5 * 1024 * 1024) {
            customSnackbar(
                "ERROR".tr,
                "Image is too large. Please select an image smaller than 5MB",
                AppColor.error);
            return;
          }

          _image = file;
          setState(() {});
          print("Image selected: ${file.path}, Size: ${fileSize} bytes");
        } else {
          customSnackbar(
              "ERROR".tr, "Failed to access selected image", AppColor.error);
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      customSnackbar("ERROR".tr, "Failed to select image: $e", AppColor.error);
    }
  }
}
