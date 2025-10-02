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
    messages.add(messageList);
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
        if (data != null) {
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
