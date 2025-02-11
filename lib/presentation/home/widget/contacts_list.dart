import 'package:flutter/material.dart';

import '../../../data/repositories/contact_repository.dart';
import '../../../data/services/service_locator.dart';
import '../../../router/app_router.dart';
import '../../chat/chat_screen.dart';

class ContactsList extends StatelessWidget {
  final ContactRepository contactRepository;
  const ContactsList({required this.contactRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Contacts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: contactRepository.getRegisteredContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final contacts = snapshot.data!;
                if (contacts.isEmpty) {
                  return const Center(child: Text("No contacts found"));
                }
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Text(contact["name"][0].toUpperCase()),
                      ),
                      title: Text(contact["name"]),
                      onTap: () => getIt<AppRouter>().push(ChatScreen(
                        receiverId: contact['id'],
                        receiverName: contact['name'],
                      )),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
