import 'package:flutter/material.dart';

import '../../../data/services/service_locator.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../router/app_router.dart';
import '../../screens/auth/login_screen.dart';
class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Chats"),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await getIt<AuthCubit>().signOut();
            getIt<AppRouter>().pushAndRemoveUntil(const LoginScreen());
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
