import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../logic/cubits/chat/chat_cubit.dart';
import '../../../logic/cubits/chat/chat_state.dart';
import '../../widgets/loading_dots.dart';
import '../chat_screen.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatScreenAppBar({
    super.key,
    required this.widget,
    required ChatCubit chatCubit,
  }) : _chatCubit = chatCubit;

  final ChatScreen widget;
  final ChatCubit _chatCubit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(widget.receiverName[0].toUpperCase()),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.receiverName),
              BlocBuilder<ChatCubit, ChatState>(
                bloc: _chatCubit,
                builder: (context, state) {
                  if (state.isReceiverTyping) {
                    return Row(
                      children: [
                        Text(
                          "typing",
                          style:
                          TextStyle(color: Theme.of(context).primaryColor),
                        ), Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: const LoadingDots(),
                        ),

                      ],
                    );
                  }
                  if (state.isReceiverOnline) {
                    return const Text(
                      "Online",
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    );
                  }
                  if (state.receiverLastSeen != null) {
                    final lastSeen = state.receiverLastSeen!.toDate();
                    return Text(
                      "last seen at ${DateFormat('h:mm a').format(lastSeen)}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ],
      ),
      actions: [
        BlocBuilder<ChatCubit, ChatState>(
          bloc: _chatCubit,
          builder: (context, state) {
            if (state.isUserBlocked) {
              return TextButton.icon(
                onPressed: () => _chatCubit.unBlockUser(widget.receiverId),
                label: const Text("Unblock"),
                icon: const Icon(Icons.block),
              );
            }
            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == "block") {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Are you sure you want to block ${widget.receiverName}?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            "Block",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _chatCubit.blockUser(widget.receiverId);
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'block',
                  child: Text("Block User"),
                ),
              ],
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
