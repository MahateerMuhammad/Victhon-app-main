import 'dart:io';
import 'package:Victhon/app/customerApp/inbox/controller/inbox_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widget/textwidget.dart';

class ChatMediaView extends StatefulWidget {
  const ChatMediaView({
    super.key,
    required this.mediaFile,
    required this.customerID,
  });
  final File mediaFile;
  final String customerID;

  @override
  State<ChatMediaView> createState() => _ChatMediaViewState();
}

class _ChatMediaViewState extends State<ChatMediaView> {
  final inboxController = Get.put(InboxController());
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
              child: Icon(
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
            onTap: isSending? (){}:
            () async {
              print("got hereeee");
              setState(() {
                isSending = true;
              });

              if (_selectedMedia != null) {
                print("imageurl------ : $_selectedMedia");
                String mediaString = await inboxController.uploadImage(
                    imageFile: _selectedMedia!);
                inboxController.sendMessage(
                  widget.customerID,
                  mediaString,
                );
                inboxController.addMessage({
                  "content": mediaString,
                  "isCurrentUser": true,
                  "createdAt": now.toIso8601String(),
                });
                isSending = false;
                setState(() {});
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

Future<void> pickMedia(ImageSource source, String customerID) async {
  final pickedFile = await picker.pickImage(source: source);
  if (pickedFile != null) {
    _selectedMedia = File(pickedFile.path);
    Get.to(() => ChatMediaView(
          mediaFile: _selectedMedia!,
          customerID: customerID,
        ));
  }
}
