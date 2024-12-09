import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  Future<void> initialize() async {
    _localStream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.addStream(_localStream!);
    _peerConnection!.onIceCandidate = (candidate) {
      print('New ICE candidate: ${candidate.toMap()}');
    };
    _peerConnection!.onAddStream = (stream) {
      print('New remote stream added');
    };
  }

  MediaStream? getLocalStream() => _localStream;

  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    return offer;
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await _peerConnection!.setRemoteDescription(description);
  }
}
