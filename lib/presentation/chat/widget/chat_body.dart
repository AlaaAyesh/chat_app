import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubits/chat/chat_cubit.dart';
import '../../../logic/cubits/chat/chat_state.dart';
import 'message_bubble.dart';



class ChatBody extends StatelessWidget {
  final ChatCubit chatCubit;
  final ScrollController scrollController;
  final TextEditingController messageController;
  final bool isComposing;
  final bool showEmoji;
  final String receiverName;
  final String receiverId;
  final VoidCallback onSendMessage;
  final VoidCallback onToggleEmoji;

  const ChatBody({
    super.key,
    required this.chatCubit,
    required this.scrollController,
    required this.messageController,
    required this.isComposing,
    required this.showEmoji,
    required this.receiverName,
    required this.receiverId,
    required this.onSendMessage,
    required this.onToggleEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      bloc: chatCubit,
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ChatStatus.error) {
          return Center(child: Text(state.error ?? "Something went wrong"));
        }
        return Column(
          children: [
            if (state.amIBlocked)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.withOpacity(0.1),
                child: Text("You have been blocked by $receiverName",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center),
              ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                reverse: true,
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message = state.messages[index];
                  final isMe = message.senderId == chatCubit.currentUserId;
                  return MessageBubble(message: message, isMe: isMe);
                },
              ),
            ),
            if (!state.amIBlocked && !state.isUserBlocked)
              _buildMessageInput(context),
          ],
        );
      },
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: onToggleEmoji,
                  icon: const Icon(Icons.emoji_emotions)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: messageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none),
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: isComposing ? onSendMessage : null,
                icon: Icon(Icons.send,
                    color: isComposing
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
              ),
            ],
          ),
          if (showEmoji)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: messageController,
                config: Config(height: 250),
              ),
            ),
        ],
      ),
    );
  }
}
