
import 'package:chat_app/services/signaling_service.dart';
import 'package:chat_app/services/webrtc_service.dart';
import 'package:chat_app/video_call_screen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Call App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomIdController = TextEditingController();
  final SignalingService _signalingService = SignalingService();
  final WebRTCService _webRTCService = WebRTCService();

  @override
  void initState() {
    super.initState();
    _signalingService.connect('http://192.168.26.102:3000'); // Replace with your server URL
  }

  void _joinRoom() async {
    final roomId = _roomIdController.text.trim();
    if (roomId.isNotEmpty) {
      await _webRTCService.initialize();
      _signalingService.joinRoom(roomId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            signalingService: _signalingService,
            webRTCService: _webRTCService,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Call App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _roomIdController,
              decoration: InputDecoration(
                labelText: 'Enter Room ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinRoom,
              child: Text('Join Room'),
            ),
          ],
        ),
      ),
    );
  }
}
