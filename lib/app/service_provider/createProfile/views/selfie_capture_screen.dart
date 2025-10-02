import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Victhon/widget/app_botton.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widget/loader.dart';
import '../../../../widget/textwidget.dart';
import '../controller/provider_create_profile_controller.dart';

class SelfieCaptureScreen extends StatefulWidget {
  const SelfieCaptureScreen({super.key});

  @override
  State<SelfieCaptureScreen> createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen> {
  final createProfileController = Get.put(ProviderCreateProfileController());

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColor.whiteColor,
            elevation: 0,
            surfaceTintColor: AppColor.whiteColor,
            centerTitle: true,
            title: const TextWidget(
              text: "Confirm Selfie",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          body: _image == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
                  child: Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 150,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: FileImage(_image!),
                        ),
                      ),
                      const Spacer(),
                      AppPrimaryButton(
                        buttonText: "Use This Photo",
                        onPressed: () {
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
    );
  }
}
