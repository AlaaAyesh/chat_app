import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/io.dart';


class SignalingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;
  final DatabaseReference _db = FirebaseDatabase.instance.ref("calls");
  final IOWebSocketChannel _channel =
  IOWebSocketChannel.connect("wss://yourserver.com/socket");

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  Function(String callerId)? onIncomingCall;

  SignalingService({required this.userId});

  void startCall(String callerId, String receiverId) {
    _channel.sink.add(jsonEncode({
      "type": "call",
      "callerId": callerId,
      "receiverId": receiverId,
    }));
  }

  void listenForCalls(Function(String) onIncomingCall) {
    this.onIncomingCall = onIncomingCall;
    _channel.stream.listen((message) {
      var data = jsonDecode(message);
      if (data['type'] == 'incoming_call') {
        this.onIncomingCall?.call(data['callerId']);
      }
    });
  }

  void acceptCall(String callerId) {
    _channel.sink.add(jsonEncode({
      "type": "accept",
      "callerId": callerId,
    }));
    _initCall(callerId);
  }

  void rejectCall(String callerId) {
    _channel.sink.add(jsonEncode({
      "type": "reject",
      "callerId": callerId,
    }));
  }

  Future<void> _initCall(String receiverId) async {
    _peerConnection = await _createPeerConnection();

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _sendMessage(receiverId, "ice-candidate", jsonEncode(candidate.toMap()));
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      // Handle remote stream
    };

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    _sendMessage(receiverId, "offer", jsonEncode(offer.toMap()));
  }

  void endCall(String receiverId) {
    _peerConnection?.close();
    _peerConnection = null;
    _sendMessage(receiverId, "call-ended", "{}");
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    };
    final connection = await createPeerConnection(config);
    _localStream =
    await navigator.mediaDevices.getUserMedia({"video": true, "audio": true});
    _localStream!.getTracks().forEach((track) {
      connection.addTrack(track, _localStream!);
    });
    return connection;
  }
  void setRenderers(RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) {
    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    if (_localStream != null) {
      localRenderer.srcObject = _localStream;
    }
  }

  void _sendMessage(String receiverId, String type, String data) {
    _db.child(receiverId).set({"type": type, "data": data, "from": userId});
  }
}
