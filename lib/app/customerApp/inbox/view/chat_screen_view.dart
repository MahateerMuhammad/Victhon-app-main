import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/customerApp/inbox/controller/inbox_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/widget/textwidget.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/remote_services/network_service.dart';
import '../../../../widget/chat_icon_widget.dart';
import '../widget/chat_media_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    this.message,
    this.serivceProviderDetails,
    // required this.isNewChat,
  });
  final dynamic message;
  final dynamic serivceProviderDetails;
  // final bool isNewChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final inboxController = Get.put(InboxController());
  final ScrollController _scrollController = ScrollController();
  final networkService = Get.find<NetworkService>();

  final DateTime now = DateTime.now();
  String messageText = '';
  bool addButtonTap = false;

  @override
  void initState() {
    super.initState();
    // Load messages if we have an existing conversation
    if (widget.message != null && widget.message["_id"] != null) {
      debugPrint(
          "Loading messages for existing conversation: ${widget.message["_id"]}");
      inboxController.loadConversationMessages(widget.message["_id"]);
    } else {
      // Clear messages for new conversation
      inboxController.customerMessages.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("----------- ${widget.serivceProviderDetails}");
    return Scaffold(
      backgroundColor: AppColor.primaryCardColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        surfaceTintColor: AppColor.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Refresh conversations when going back to ensure new conversation shows up
            inboxController.refreshConversationsOnly();
            Get.back();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // Handle both existing conversation and new chat scenarios
              (widget.message != null && widget.message["otherUser"] != null)
                  ? CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.message["otherUser"]["imageUrl"],
                        errorListener: (error) => const Icon(
                          Icons.person,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    )
                  : widget.serivceProviderDetails != null
                      ? CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: CachedNetworkImageProvider(
                            widget.serivceProviderDetails["imageUrl"],
                            errorListener: (error) => const Icon(
                              Icons.person,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.person,
                            color: AppColor.whiteColor,
                          ),
                        ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: (widget.message != null &&
                            widget.message["otherUser"] != null)
                        ? widget.message["otherUser"]["fullName"]
                        : widget.serivceProviderDetails != null
                            ? widget.serivceProviderDetails["fullName"]
                            : "Unknown User",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const TextWidget(
                    text: "Service Provider",
                    fontSize: 12,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Show existing messages only if we have an existing conversation
                  (widget.message != null && widget.message["messages"] != null)
                      ? ListView.builder(
                          // reverse: true, // <-- this reverses the list visually
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16),
                          itemCount:
                              (widget.message["messages"] as List).length,
                          itemBuilder: (context, index) {
                            final reversedIndex =
                                (widget.message["messages"].length - 1) - index;
                            final msg =
                                widget.message["messages"][reversedIndex];
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
                            return const SizedBox
                                .shrink(); // Return empty widget if content is empty
                          },
                        )
                      : const SizedBox(), // No existing messages for new chat
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
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: inboxController.customerMessages.length,
                      itemBuilder: (context, index) {
                        final msg = inboxController.customerMessages[index];
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
                            controller: inboxController.messageController,
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
                                  const EdgeInsets.fromLTRB(16, 8, 16, 30),
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
                              onTap: () async {
                                if (messageText.trim().isNotEmpty) {
                                  // Get receiver ID from either existing conversation or service provider details
                                  String receiverId = (widget.message != null &&
                                          widget.message["otherUser"] != null)
                                      ? widget.message["otherUser"]["userId"]
                                      : widget.serivceProviderDetails["userId"];

                                  // Add message locally first for immediate UI feedback
                                  inboxController.addMessage({
                                    "content": messageText,
                                    "isCurrentUser": true,
                                    "createdAt": now.toIso8601String(),
                                  });

                                  String currentMessage = messageText;
                                  inboxController.messageController.clear();
                                  setState(() {
                                    messageText = '';
                                  });

                                  // Send message to backend
                                  await inboxController.sendMessage(
                                    receiverId,
                                    currentMessage,
                                  );

                                  debugPrint(
                                      "_________________ ${inboxController.customerMessages}");
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
                              child: CircleAvatar(
                                backgroundColor: addButtonTap
                                    ? AppColor.primaryColor
                                    : AppColor.primaryCardColor,
                                radius: 30,
                                child: Icon(
                                  Icons.add,
                                  size: 35,
                                  color: addButtonTap
                                      ? AppColor.whiteColor
                                      : AppColor.primaryColor,
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
                                    String receiverId = (widget.message !=
                                                null &&
                                            widget.message["otherUser"] != null)
                                        ? widget.message["otherUser"]["userId"]
                                        : widget
                                            .serivceProviderDetails["userId"];
                                    pickMedia(ImageSource.camera, receiverId);
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
                                    String receiverId = (widget.message !=
                                                null &&
                                            widget.message["otherUser"] != null)
                                        ? widget.message["otherUser"]["userId"]
                                        : widget
                                            .serivceProviderDetails["userId"];
                                    pickMedia(ImageSource.gallery, receiverId);
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
        padding: const EdgeInsets.only(bottom: 16),
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
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
