import 'package:chat_app/presentation/setting/widgets/settings_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../config/theme/theme_cubit.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/services/service_locator.dart';
import '../../logic/cubits/auth/auth_cubit.dart';
import '../../logic/cubits/chat/chat_cubit.dart';
import '../../router/app_router.dart';
import '../auth/login/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ChatCubit(chatRepository: ChatRepository(), currentUserId: "USER_ID"),
        child: SettingsBody(),
      )
      ,
    );
  }

  Future<void> _logout(BuildContext context) async {
    await getIt<AuthCubit>().signOut();
    getIt<AppRouter>().pushAndRemoveUntil(const LoginScreen());
  }
}

