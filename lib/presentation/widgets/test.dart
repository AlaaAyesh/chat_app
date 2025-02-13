import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallScreen extends StatefulWidget {
  final String callerName;
  final String receiverId;
  final String callId; // Unique call document ID
  final RTCPeerConnection peerConnection;

  const CallScreen({
    super.key,
    required this.callerName,
    required this.receiverId,
    required this.callId,
    required this.peerConnection,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isMuted = false;
  Timer? _timer;
  int _seconds = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _callSubscription;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _listenForCallEnd();
  }

  /// 🔹 Starts the call timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  /// 🔹 Listens for call termination
  void _listenForCallEnd() {
    _callSubscription = _firestore.collection('calls').doc(widget.callId).snapshots().listen((snapshot) {
      if (!snapshot.exists) {
        _terminateCallLocally();
      }
    });
  }

  /// 🔹 Ends the call for both users
  Future<void> _endCall() async {
    _timer?.cancel();
    await widget.peerConnection.close();

    // Mark the call as ended in Firestore
    await _firestore.collection('calls').doc(widget.receiverId).update({
      'status': 'ended',
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  /// 🔹 Handles call termination when other user hangs up
  void _terminateCallLocally() {
    _timer?.cancel();
    _callSubscription?.cancel();
    widget.peerConnection.close();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  /// 🔹 Toggles the mute state
  Future<void> _toggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });

    List<RTCRtpSender> senders = await widget.peerConnection.getSenders();
    for (var sender in senders) {
      if (sender.track?.kind == "audio") {
        sender.track?.enabled = !isMuted;
      }
    }
  }

  /// 🔹 Formats seconds into mm:ss format
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _callSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueGrey,
            child: Text(
              widget.callerName[0].toUpperCase(),
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.callerName,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            _formatDuration(_seconds),
            style: const TextStyle(fontSize: 20, color: Colors.green),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  isMuted ? Icons.mic_off : Icons.mic,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: _toggleMute,
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                child: const Icon(Icons.call_end, size: 32),
                onPressed: _endCall,
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
