import 'package:chat_app/presentation/chat/widget/chat_body.dart';
import 'package:chat_app/presentation/chat/widget/chat_screen_app_bar.dart';
import 'package:flutter/material.dart';
import '../../data/models/chat_message.dart';
import '../../data/services/service_locator.dart';
import '../../logic/cubits/chat/chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  const ChatScreen(
      {super.key, required this.receiverId, required this.receiverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  late final ChatCubit _chatCubit;
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _previousMessages = [];
  bool _isComposing = false;
  bool _showEmoji = false;

  @override
  void initState() {
    super.initState();
    _chatCubit = getIt<ChatCubit>();
    _chatCubit.enterChat(widget.receiverId);
    messageController.addListener(_onTextChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _chatCubit.loadMoreMessages();
    }
  }

  void _onTextChanged() {
    final isComposing = messageController.text.isNotEmpty;
    if (isComposing != _isComposing) {
      setState(() => _isComposing = isComposing);
      if (isComposing) _chatCubit.startTyping();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _handleSendMessage() async {
    final messageText = messageController.text.trim();
    messageController.clear();
    await _chatCubit.sendMessage(
        content: messageText, receiverId: widget.receiverId);
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    _chatCubit.leaveChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatScreenAppBar(widget: widget, chatCubit: _chatCubit),
      body: ChatBody(
        chatCubit: _chatCubit,
        scrollController: _scrollController,
        messageController: messageController,
        isComposing: _isComposing,
        showEmoji: _showEmoji,
        receiverName: widget.receiverName,
        receiverId: widget.receiverId,
        onSendMessage: _handleSendMessage,
        onToggleEmoji: () => setState(() => _showEmoji = !_showEmoji),
      ),
    );
  }
}
