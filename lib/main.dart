import 'package:chat_app/presentation/auth/login/login_screen.dart';
import 'package:chat_app/presentation/home/home_screen.dart';
import 'package:chat_app/presentation/main/main_screen.dart';
import 'package:chat_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/app_theme.dart';
import 'config/theme/theme_cubit.dart';
import 'data/repositories/chat_repository.dart';
import 'data/services/service_locator.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/auth/auth_state.dart';
import 'logic/cubits/chat/chat_cubit.dart';
import 'logic/observer/app_life_cycle_observer.dart';

void main() async {
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLifeCycleObserver _lifeCycleObserver;

  @override
  void initState() {
    getIt<AuthCubit>().stream.listen((state) {
      if (state.status == AuthStatus.authenticated && state.user != null) {
        _lifeCycleObserver = AppLifeCycleObserver(
            userId: state.user!.uid, chatRepository: getIt<ChatRepository>());
      }
      WidgetsBinding.instance.removeObserver(_lifeCycleObserver); // Remove old observer

      WidgetsBinding.instance.addObserver(_lifeCycleObserver);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatCubit(chatRepository: ChatRepository(), currentUserId: "USER_ID")), // Chat management

        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()), // ThemeCubit added
      ],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, theme) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MaterialApp(
                title: 'Chat App',
                navigatorKey: getIt<AppRouter>().navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: theme, // Dynamically applied theme
                home: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.initial) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state.status == AuthStatus.authenticated) {
                      return const MainScreen();
                    }
                    return const LoginScreen();
                  },
                ),
              ),
            );
          },
        )
    );
  }
}
