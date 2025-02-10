import 'package:flutter/material.dart';

import '../../../data/repositories/contact_repository.dart';
import '../../../data/services/service_locator.dart';
import 'contacts_list.dart';
class ContactsButton extends StatelessWidget {
  const ContactsButton({super.key});

  void _showContactsList(BuildContext context) {
    final contactRepository = getIt<ContactRepository>();
    showModalBottomSheet(
      context: context,
      builder: (_) => ContactsList(contactRepository: contactRepository),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showContactsList(context),
      child: const Icon(Icons.chat, color: Colors.white),
    );
  }
}
