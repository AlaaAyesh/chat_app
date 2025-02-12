import 'package:flutter/material.dart';

import '../../../data/repositories/contact_repository.dart';
import '../../../data/services/service_locator.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../router/app_router.dart';
import '../../auth/login/login_screen.dart';
import 'contacts_list.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});
  void _showContactsList(BuildContext context) {
    final contactRepository = getIt<ContactRepository>();
    showModalBottomSheet(
      context: context,
      builder: (_) => ContactsList(contactRepository: contactRepository),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Chats"),
      actions: [
        IconButton(
            onPressed: () => _showContactsList(context),
            icon: const Icon(Icons.contacts_outlined)
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
