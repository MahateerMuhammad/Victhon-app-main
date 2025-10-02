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
    print('############## Connected to socket server ##########');
  });

  socket.onDisconnect((_) {
    print('Disconnected from socket server');
  });

  socket.onConnectError((data) => print('Connect error: $data'));
  socket.onError((data) => print('Socket error: $data'));
}
