import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/app_color.dart';
import '../controller/services_controller.dart';
import 'image_cancel_dialog.dart';

class ImagesContainer extends StatefulWidget {
  const ImagesContainer({
    super.key,
    required this.height,
    this.width,
  });
  final double height;
  final double? width;
  

  @override
  State<ImagesContainer> createState() => _ImagesContainerState();
}

class _ImagesContainerState extends State<ImagesContainer> {
  final servicesController = Get.put(ServicesController());

  File? _selectedImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        servicesController.serviceImages.add(_selectedImage);
      });

      print("object ********* ${_selectedImage}");
      print("service image ********* ${servicesController.serviceImages}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.primaryColor.shade50,
        ),
        child: _selectedImage == null
            ? Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              )
            : Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    // Display the selected image
                    borderRadius: BorderRadius.circular(4),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showImageCancelDialog(
                        context: context,
                        onDelete: () {
                          setState(() {
                            servicesController.serviceImages
                                .remove(_selectedImage);
                            _selectedImage = null;
                          });
                        },
                        onReplace: () async {
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              final newImage = File(pickedFile.path);
                              servicesController.serviceImages
                                  .remove(_selectedImage);
                              servicesController.serviceImages.add(newImage);
                              _selectedImage = newImage;
                            });
                          }
                        },
                      );
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 30,
                      color: AppColor.redColor1,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
