import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/services/service_locator.dart';
import '../../../router/app_router.dart';
import '../../chat/chat_screen.dart';
import '../../widgets/chat_list_tile.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRepository = getIt<ChatRepository>();
    final currentUserId = getIt<AuthRepository>().currentUser?.uid ?? "";

    return StreamBuilder(
      stream: chatRepository.getChatRooms(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Center(child: Text("Error: \${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final chats = snapshot.data!;
        if (chats.isEmpty) {
          return const Center(child: Text("No recent chats"));
        }
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final otherUserId = chat.participants.firstWhere((id) => id != currentUserId);
            final otherUserName = chat.participantsName?[otherUserId] ?? "Unknown";
            return ChatListTile(
              chat: chat,
              currentUserId: currentUserId,
              onTap: () => getIt<AppRouter>().push(ChatScreen(
                receiverId: otherUserId,
                receiverName: otherUserName,
              )),
            );
          },
        );
      },
    );
  }
}
