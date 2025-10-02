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
    print("heyyyyyyyy fetch conversation");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerMessages.clear();
    // Check if services exist in local storage
    String? savedConversationDetails = prefs.getString("cached_conversations");

    if (savedConversationDetails != null) {
      print("savedConversationDetails: $savedConversationDetails");

      conversationDetails.value =
          List<Map>.from(json.decode(savedConversationDetails)).toList();
    }
    isLoading(true);

    // Fetch new services from API
    final response = await RemoteServices().getConversation();
    // print("@@@@@@@@@@ ${response["conversations"]} @@@@@@@@@@");
    print("@@@@@@@@@@ ${response.runtimeType} @@@@@@@@@@");
    isLoading(false);

    if (response is Map<String, dynamic>) {
      conversationDetails.value = response["conversations"];
      await prefs.setString(
          "cached_conversations", json.encode(response["conversations"]));
      print("cached_conversations ${prefs.getString("cached_conversations")}");
    }
  }

  addMessage(messageList) {
    print("get hereeeee");
    customerMessages.add(messageList);
    print("messages: $customerMessages");
  }

  sendMessage(
    String receiverId,
    String content,
  ) {
    socket.emitWithAck(
      "directMessage",
      {
        "receiverId": receiverId,
        "content": content,
      },
      ack: (dynamic data) {
        // messageSent.add(false);

        if (data != null) {
          // messageSent.add(data["success"]);
          print("Ack received: $data");
        } else {
          print("No ack received");
        }
      },
    );
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
