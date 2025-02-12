import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/chat_message.dart';

enum ChatStatus {
  inital,
  loading,
  loaded,
  error,
}

class ChatState extends Equatable {
  final ChatStatus status;
  final String? error;
  final String? receiverId;
  final String? chatRoomId;
  final List<ChatMessage> messages;
  final bool isReceiverTyping;
  final bool isReceiverOnline;
  final Timestamp? receiverLastSeen;
  final bool hasMoreMessages;
  final bool isLoadingMore;
  final bool isUserBlocked;
  final bool amIBlocked;
  final List<Map<String, String>> blockedUsers; // Store both userId and name

  const ChatState({
    this.status = ChatStatus.inital,
    this.error,
    this.receiverId,
    this.chatRoomId,
    this.messages = const [],
    this.isReceiverTyping = false,
    this.isReceiverOnline = false,
    this.receiverLastSeen,
    this.hasMoreMessages = true,
    this.isLoadingMore = false,
    this.isUserBlocked = false,
    this.amIBlocked = false,
    this.blockedUsers = const [], // ✅ Initialize with empty list

  });

  ChatState copyWith({
    ChatStatus? status,
    String? error,
    String? receiverId,
    String? chatRoomId,
    List<ChatMessage>? messages,
    bool? isReceiverTyping,
    bool? isReceiverOnline,
    Timestamp? receiverLastSeen,
    bool? hasMoreMessages,
    bool? isLoadingMore,
    bool? isUserBlocked,
    bool? amIBlocked,
    List<Map<String, String>>? blockedUsers,

  }) {
    return ChatState(
      status: status ?? this.status,
      error: error ?? this.error,
      receiverId: receiverId ?? this.receiverId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      messages: messages ?? this.messages,
      isReceiverTyping: isReceiverTyping ?? this.isReceiverTyping,
      isReceiverOnline: isReceiverOnline ?? this.isReceiverOnline,
      receiverLastSeen: receiverLastSeen ?? this.receiverLastSeen,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isUserBlocked: isUserBlocked ?? this.isUserBlocked,
      amIBlocked: amIBlocked ?? this.amIBlocked,
      blockedUsers: blockedUsers ?? List.from(this.blockedUsers), // ✅ Ensures a new list reference

    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      error,
      receiverId,
      chatRoomId,
      messages,
      isReceiverTyping,
      isReceiverOnline,
      receiverLastSeen,
      hasMoreMessages,
      isLoadingMore,
      isUserBlocked,
      amIBlocked,
      blockedUsers, // ✅ Add blockedUsers to Equatable props

    ];
  }
}
