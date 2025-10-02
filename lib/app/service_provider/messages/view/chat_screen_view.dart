import 'package:Victhon/app/service_provider/messages/widget/provider_chat_media_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/widget/textwidget.dart';

import '../../../../data/remote_services/network_service.dart';
import '../../../../widget/chat_icon_widget.dart';
import '../controller/message_controller.dart';

class ServiceProviderChatScreen extends StatefulWidget {
  const ServiceProviderChatScreen({
    super.key,
    this.message,
    this.customerDetails,
    // required this.isNewChat,
  });
  final dynamic message;
  final dynamic customerDetails;
  // final bool isNewChat;

  @override
  State<ServiceProviderChatScreen> createState() =>
      _ServiceProviderChatScreenState();
}

class _ServiceProviderChatScreenState extends State<ServiceProviderChatScreen> {
  final messageController = Get.put(MessageController());
  final ScrollController _scrollController = ScrollController();
  final networkService = Get.find<NetworkService>();

  final DateTime now = DateTime.now();
  String messageText = '';
  bool addButtonTap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryCardColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        surfaceTintColor: AppColor.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              widget.message["otherUser"] == null
                  ? CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        color: AppColor.whiteColor,
                      ),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColor.primaryColor.shade100,
                      child: ClipOval(
                        child: CachedNetworkImage(
                            imageUrl: widget.message["otherUser"]["imageUrl"],
                            fit: BoxFit.cover,
                            width: 44,
                            height: 44,
                            errorWidget: (context, url, error) => const Icon(
                                  Icons.person,
                                  color: AppColor.whiteColor,
                                  size: 28,
                                ),
                            placeholder: (context, url) => const SizedBox()),
                      ),
                    ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // widget.isNewChat
                  //     ? TextWidget(
                  //         text: widget.customerDetails["fullName"],
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.black,
                  //       )
                  //     :
                  TextWidget(
                    text: widget.message["otherUser"] == null
                        ? "Unknown User"
                        : widget.message["otherUser"]["fullName"],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const TextWidget(
                    text: "Customer",
                    fontSize: 12,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              LucideIcons.phone,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.video, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // widget.isNewChat
                  //     ? const SizedBox()
                  //     :
                  ListView.builder(
                    reverse: true, // <-- this reverses the list visually
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: (widget.message["messages"] as List).length,
                    itemBuilder: (context, index) {
                      // final reversedIndex =
                      //     (widget.message["messages"].length - 1) - index;
                      final msg = widget.message["messages"][index];
                      final isSender = msg["isCurrentUser"] == true;
                      final formattedTime =
                          formatChatTimestamp(msg["timestamp"]);

                      if (msg["content"].toString().isNotEmpty) {
                        return msg["content"].toString().contains("http")
                            ? _imageMessageBubble(
                                imageUrl: msg["content"],
                                time: formattedTime,
                                isSender: isSender,
                              )
                            : _messageBubble(
                                message: msg["content"],
                                time: formattedTime,
                                isSender: isSender,
                              );
                      }
                    },
                  ),
                  Obx(() {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: messageController.messages.length,
                      itemBuilder: (context, index) {
                        final msg = messageController.messages[index];
                        final isSender = msg["isCurrentUser"];
                        final formattedTime =
                            formatChatTimestamp(msg["createdAt"]);

                        return msg["content"].toString().contains("http")
                            ? _imageMessageBubble(
                                imageUrl: msg["content"],
                                time: formattedTime,
                                isSender: isSender,
                              )
                            : _messageBubble(
                                message: msg["content"],
                                time: formattedTime,
                                isSender: isSender,
                                isSeen: true,
                              );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border(
              //   top: BorderSide(color: Colors.grey.shade300),
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          // height: 56,
                          child: TextField(
                            controller: messageController.messageController,
                            onChanged: (value) {
                              setState(() {
                                messageText = value;
                              });
                            },
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Type here.......",
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: AppColor.primaryCardColor,
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 8, 16, 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      messageText.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                if (messageText.trim().isNotEmpty) {
                                  messageController.sendMessage(
                                    // widget.isNewChat
                                    //     ? widget.customerDetails["_id"]
                                    //     :
                                    widget.message["otherUser"]["userId"],
                                    messageText,
                                  );
                                  messageController.addMessage({
                                    "content": messageText,
                                    "isCurrentUser": true,
                                    "createdAt": now.toIso8601String(),
                                  });
                                  print(
                                      "_________________ ${messageController.messages}");
                                  messageController.messageController.clear();
                                  setState(() {
                                    messageText = '';
                                  });
                                }
                              },
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColor.primaryColor,
                                child: Icon(
                                  Icons.send_rounded,
                                  size: 35,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                addButtonTap = !addButtonTap;
                                setState(() {});
                              },
                              child: const CircleAvatar(
                                backgroundColor: AppColor.primaryCardColor,
                                radius: 30,
                                child: Icon(
                                  Icons.add,
                                  size: 35,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                    ],
                  ),
                  addButtonTap
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChatIconButton(
                                  buttonText: "Camera",
                                  textColor: AppColor.blackColor,
                                  icon: Icon(
                                    Icons.video_camera_back,
                                    color: AppColor.blackColor.withOpacity(0.7),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    providerPickMedia(ImageSource.camera,
                                        widget.message["otherUser"]["userId"]);
                                  },
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                ChatIconButton(
                                  buttonText: "Album",
                                  textColor: AppColor.blackColor,
                                  icon: Icon(
                                    Icons.image,
                                    color: AppColor.blackColor.withOpacity(0.7),
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    providerPickMedia(ImageSource.gallery,
                                        widget.message["otherUser"]["userId"]);
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chat Bubble Widget
  Widget _messageBubble(
      {required String message,
      required String time,
      required bool isSender,
      bool isSeen = false}) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: isSender
            ? const EdgeInsets.fromLTRB(32, 0, 0, 16)
            : const EdgeInsets.fromLTRB(0, 0, 32, 16),
        decoration: BoxDecoration(
          color: isSender ? Colors.yellow.shade100 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isSender ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight:
                isSender ? const Radius.circular(0) : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                if (isSender)
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: networkService.isConnected.value
                        ? const Icon(Icons.done_all,
                            color: Colors.grey, size: 16)
                        : const Icon(
                            Icons.done,
                            color: Colors.grey,
                            size: 16,
                          ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Image Message Bubble
  Widget _imageMessageBubble(
      {required String imageUrl,
      required String time,
      required bool isSender}) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: 240,
                height: 220,
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  color: AppColor.whiteColor,
                  size: 28,
                ),
                placeholder: (context, url) => const SizedBox(),
              ),
              Positioned(
                bottom: 6,
                right: 10,
                child: Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
