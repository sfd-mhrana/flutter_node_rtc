import 'package:socket_io_client/socket_io_client.dart' as IO;

class SignalingService {
  late IO.Socket _socket;

  void connect(String serverUrl) {
    _socket = IO.io(serverUrl, IO.OptionBuilder().setTransports(['websocket']).build());
    _socket.onConnect((_) {
      print('Connected to signaling server');
    });
  }

  void joinRoom(String roomId) {
    _socket.emit('join-room', roomId);
  }

  void sendSignal(String to, dynamic signal) {
    _socket.emit('signal', {'to': to, 'signal': signal});
  }

  void listenToSignals(Function(dynamic) onSignalReceived) {
    _socket.on('signal', (data) {
      onSignalReceived(data);
    });
  }
}
