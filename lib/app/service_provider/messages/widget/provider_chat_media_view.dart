import 'dart:io';
import 'package:Victhon/app/service_provider/messages/controller/message_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class ProviderChatMediaView extends StatefulWidget {
  const ProviderChatMediaView({
    super.key,
    required this.mediaFile,
    required this.customerID,
  });
  final File mediaFile;
  final String customerID;

  @override
  State<ProviderChatMediaView> createState() => _ProviderChatMediaViewState();
}

class _ProviderChatMediaViewState extends State<ProviderChatMediaView> {
  final chatController = Get.put(MessageController());
  final DateTime now = DateTime.now();
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.close,
                size: 30,
              )),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: _selectedMedia == null
          ? const TextWidget(text: "No Image")
          : Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Image.file(
                _selectedMedia!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: isSending
                ? () {}
                : () async {
                    print("got hereeee");
                    setState(() {
                      isSending = true;
                    });

                    if (_selectedMedia != null) {
                      String mediaString = await chatController.uploadImage(
                          imageFile: _selectedMedia!);
                      chatController.sendMessage(
                        widget.customerID,
                        mediaString,
                      );
                      chatController.addMessage({
                        "content": mediaString,
                        "isCurrentUser": true,
                        "createdAt": now.toIso8601String(),
                      });
                      setState(() {
                        isSending = false;
                      });
                    }
                    Get.back();
                  },
            child: CircleAvatar(
              radius: 32,
              backgroundColor: AppColor.primaryColor,
              child: Center(
                child: isSending
                    ? const CircularProgressIndicator(
                        color: AppColor.whiteColor,
                      )
                    : const Icon(
                        Icons.send_rounded,
                        size: 35,
                        color: AppColor.whiteColor,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

File? _selectedMedia; // Holds the selected image
final ImagePicker picker = ImagePicker();

Future<void> providerPickMedia(ImageSource source, String customerID) async {
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    _selectedMedia = File(pickedFile.path);
    Get.to(() => ProviderChatMediaView(
          mediaFile: _selectedMedia!,
          customerID: customerID,
        ));
  }
}
