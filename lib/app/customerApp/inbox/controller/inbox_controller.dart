import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/remote_services/remote_services.dart';
import '../../../../data/server/app_server.dart';
import '../../../../data/server/socket_server.dart';

class InboxController extends GetxController {
  final isLoading = false.obs;
  var remainingTimerTime = 5.obs;
  Timer? timer;

  final TextEditingController messageController = TextEditingController();
  RxList<dynamic> conversationDetails = <dynamic>[].obs;

  RxList<dynamic> customerMessages = <dynamic>[].obs;
  // RxList<bool> messageSent = <bool>[].obs;

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
    try {
      print("Fetching conversations...");
      isLoading(true);
      
      // Load cached conversations first for faster UI
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString("cached_conversations");
      if (cached != null && cached != "[]") {
        conversationDetails.value = List<Map>.from(json.decode(cached));
        print("Loaded ${conversationDetails.length} cached conversations");
      }
      
      // Fetch fresh data from API in background
      final response = await RemoteServices().getConversation();
      
      if (response is Map<String, dynamic> && response["conversations"] != null) {
        conversationDetails.value = List<Map>.from(response["conversations"]);
        
        // Cache the new data
        await prefs.setString("cached_conversations", json.encode(response["conversations"]));
        print("Updated with ${conversationDetails.length} conversations from API");
      }
      
    } catch (e) {
      print("Error fetching conversations: $e");
    } finally {
      isLoading(false);
    }
  }

  addMessage(messageList) {
    print("get hereeeee");
    
    // Check for duplicates before adding
    bool exists = customerMessages.any((m) => 
      m["content"] == messageList["content"] && 
      m["createdAt"] == messageList["createdAt"] &&
      m["isCurrentUser"] == messageList["isCurrentUser"]
    );
    
    if (!exists) {
      customerMessages.add(messageList);
      print("New message added: $messageList");
    } else {
      print("Duplicate message ignored: $messageList");
    }
    
    print("Total messages: ${customerMessages.length}");
  }

  void refreshConversationsOnly() {
    // Only refresh the conversation list without interfering with current chat
    fetchConversation();
  }

  Future<void> refreshConversations() async {
    // Force refresh without loading indicator for pull-to-refresh
    try {
      final response = await RemoteServices().getConversation();
      
      if (response is Map<String, dynamic> && response["conversations"] != null) {
        conversationDetails.value = List<Map>.from(response["conversations"]);
        
        // Cache the new data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("cached_conversations", json.encode(response["conversations"]));
        print("Refreshed with ${conversationDetails.length} conversations");
      }
    } catch (e) {
      print("Error refreshing conversations: $e");
    }
  }

  Future<void> loadConversationMessages(String conversationId, {bool clearFirst = true}) async {
    try {
      if (clearFirst) {
        customerMessages.clear();
      }
      isLoading(true);
      
      final response = await RemoteServices().getConversationMessages(conversationId);
      
      if (response is Map<String, dynamic> && response["messages"] != null) {
        List<dynamic> messages = response["messages"];
        if (clearFirst) {
          customerMessages.assignAll(messages);
        } else {
          // Avoid duplicates when not clearing first
          for (var message in messages) {
            bool exists = customerMessages.any((m) => 
              m["content"] == message["content"] && 
              m["createdAt"] == message["createdAt"]
            );
            if (!exists) {
              customerMessages.add(message);
            }
          }
        }
        print("Loaded ${messages.length} messages for conversation $conversationId");
      }
      
      isLoading(false);
    } catch (e) {
      print("Error loading conversation messages: $e");
      isLoading(false);
    }
  }

  Future<void> sendMessage(
    String receiverId,
    String content,
  ) async {
    try {
      // Only send message via HTTP API to persist to database
      // The backend should handle real-time notifications via socket
      final response = await RemoteServices().sendMessage(
        receiverId: receiverId,
        content: content,
      );
      
      print("Send message response: $response");
      
      // Remove socket emission to prevent duplicates
      // The backend will handle real-time updates via socket
      
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<String> uploadImage({
    required File imageFile,
  }) async {
    isLoading(true);
    try {
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
        String errorMessage = response.errorMessage ?? "network error";
        Get.snackbar(
          "ERROR".tr,
          errorMessage,
        );
      }
    } catch (e) {
      print("!!!!!! $e");
    }
    return "";
  }
}
