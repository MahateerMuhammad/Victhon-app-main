import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../data/server/socket_server.dart';

class MessageController extends GetxController {
  final isLoading = false.obs;
  var remainingTimerTime = 5.obs;
  Timer? timer;
  final TextEditingController messageController = TextEditingController();

  RxList<dynamic> conversationDetails = <dynamic>[].obs;

  RxList<dynamic> messages = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversation();

    socket.on("newMessage", (data) {
      addMessage(data);
      print("Joined room: $data");
    });
  }

  Future<void> fetchConversation() async {
    isLoading(true);
    print("heyyyyyyyy fetch conversation");
    messages.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // // Check if services exist in local storage
    String? savedConversationDetails = prefs.getString("cached_conversations");
    if (savedConversationDetails != null) {
      conversationDetails.value =
          List<Map>.from(json.decode(savedConversationDetails)).toList();
    }

    // Fetch new services from API
    final response = await RemoteServices().getConversation();
    print("@@@@@@@@@@ ${response["conversations"]} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isLoading(false);

    if (response is Map<String, dynamic>) {
      conversationDetails.value = response["conversations"];
      await prefs.setString(
          "cached_conversations", json.encode(response["conversations"]));
    }
  }

  addMessage(messageList) {
    // Check for duplicates before adding
    bool exists = messages.any((m) => 
      m["content"] == messageList["content"] && 
      m["createdAt"] == messageList["createdAt"] &&
      m["isCurrentUser"] == messageList["isCurrentUser"]
    );
    
    if (!exists) {
      messages.add(messageList);
      print("Provider: New message added: $messageList");
    } else {
      print("Provider: Duplicate message ignored: $messageList");
    }
    
    print("Provider total messages: ${messages.length}");
  }

  Future<void> sendMessage(
    String receiverId,
    String content,
  ) async {
    try {
      // Use HTTP API to persist message to database
      // The backend should handle real-time notifications via socket
      final response = await RemoteServices().sendMessage(
        receiverId: receiverId,
        content: content,
      );
      
      print("Provider send message response: $response");
      
      // Remove socket emission to prevent duplicates
      // The backend will handle real-time updates via socket
      
    } catch (e) {
      print("Error sending message from provider: $e");
    }
  }

      Future<String> uploadImage({
    required File imageFile,
  }) async {
    isLoading(true);
    ApiResponse response =
        await RemoteServices().uploadMedia(imageFile: imageFile);
    isLoading(false);

    if (response.isSuccess) {
      // ✅ Check if widget is still mounted before using BuildContext

      final dynamic responseData = json.decode(response.data);
      print("type ${responseData.runtimeType}");

      print("responseData $responseData");
      return responseData["imageUrl"];
    } else {
      print(response.errorMessage);
      const errorMessage = "An error occurred";
      Get.snackbar(
        "ERROR".tr,
        errorMessage,
      );
    }
    return "";
  }
}
