import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 64 : 8,
          right: isMe ? 8 : 64,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              16,
            )),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.timestamp.toDate()),
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
                if (isMe) ...[
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: message.status == MessageStatus.read
                        ? Colors.lightBlueAccent
                        : Colors.white,
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
