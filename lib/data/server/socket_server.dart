import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../main.dart';
import '../../utils/api_list.dart';

late IO.Socket socket;
// final networkService = Get.find<NetworkService>();

void initSocket() {
  socket = IO.io(
    ApiList.socketUrl,
    IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders({
      "Authorization": "Bearer ${box.read('token')}",
    }).build(),
  );

  socket.onConnect((_) {
    debugPrint('############## Connected to socket server ##########');
  });

  socket.onDisconnect((_) {
    debugPrint('Disconnected from socket server');
  });

  socket.onConnectError((data) => debugPrint('Connect error: $data'));
  socket.onError((data) => debugPrint('Socket error: $data'));
}
