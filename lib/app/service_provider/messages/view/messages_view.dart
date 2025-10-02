import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Victhon/app/service_provider/messages/controller/message_controller.dart';
import 'package:Victhon/config/theme/app_color.dart';
import 'package:Victhon/app/service_provider/messages/view/chat_screen_view.dart';
import 'package:Victhon/app/service_provider/messages/view/no_messages_view.dart';
import 'package:Victhon/utils/functions.dart';
import 'package:Victhon/widget/textwidget.dart';

class ServiceProviderMessagesScreen extends StatelessWidget {
  final messageController = Get.put(MessageController());

  ServiceProviderMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.blackColor),
          onPressed: () => Get.back(),
        ),
        title: const TextWidget(
          text: "Messages",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColor.blackColor,
        ),
        centerTitle: true,
        // actions: [
        //   TextButton.icon(
        //     onPressed: () {},
        //     icon:
        //         const Icon(Icons.history, size: 18, color: AppColor.blueColor),
        //     label: const Text(
        //       "Call History",
        //       style: TextStyle(
        //         color: AppColor.blueColor,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(Icons.search,
                    color: AppColor.blackColor.withOpacity(0.4)),
                hintText: "Search",
                hintStyle:
                    TextStyle(color: AppColor.blackColor.withOpacity(0.5)),
                filled: true,
                fillColor: AppColor.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.primaryColor.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColor.primaryColor.shade100),
                ),
              ),
            ),
          ),
          Obx(() {
            if (messageController.isLoading.isTrue) {
              return const SizedBox();
            } else {
              if (messageController.conversationDetails.isEmpty) {
                return const NoMessagesView(
                  userType: "service Provider",
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messageController.conversationDetails.length,
                    itemBuilder: (context, index) {
                      final message =
                          messageController.conversationDetails[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ServiceProviderChatScreen(
                                    message: message,
                                    // isNewChat: false,
                                  ))!
                              .then((_) {
                            Get.find<MessageController>().fetchConversation();
                          });
                        },
                        child: _messageTile(
                          message["otherUser"] == null
                              ? "No image"
                              : message["otherUser"]["imageUrl"],
                          message["otherUser"] == null
                              ? "Unknown User"
                              : message["otherUser"]["fullName"],
                          message["lastMessage"].toString().contains("http")
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      size: 20,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const TextWidget(
                                      text: "Picture",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                )
                              : TextWidget(
                                  text: message['lastMessage'],
                                  maxLines: 1,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400,
                                ),
                          formatChatTimestamp(message["timestamp"]),
                          0,
                        ),
                      );
                    },
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  // Message Tile Widget
  Widget _messageTile(String profileImage, String name, Widget message,
      String time, int unread) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.primaryCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Profile Image
          profileImage == "No image"
              ? CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    color: AppColor.whiteColor,
                  ),
                )
              : CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColor.primaryColor.shade100,
                  child: ClipOval(
                    child: CachedNetworkImage(
                        imageUrl: profileImage,
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
          const SizedBox(width: 12),

          // Message Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: name,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 4,
                ),
                message
              ],
            ),
          ),

          // Time & Unread Count
          Column(
            children: [
              TextWidget(
                text: time,
                color: AppColor.blackColor.withOpacity(0.7),
                fontSize: 12,
              ),
              const SizedBox(height: 8),
              unread == 0
                  ? const SizedBox()
                  : CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColor.primaryColor,
                      child: Text(
                        unread.toString(),
                        style: const TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
