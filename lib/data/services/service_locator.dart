import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../config/theme/theme_cubit.dart';
import '../../firebase_options.dart';
import '../../logic/cubits/auth/auth_cubit.dart';
import '../../logic/cubits/chat/chat_cubit.dart';
import '../../presentation/home/home_screen.dart';
import '../../router/app_router.dart';
import '../repositories/auth_repository.dart';
import '../repositories/chat_repository.dart';
import '../repositories/contact_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register core services
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register repositories
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(() => ContactRepository());
  getIt.registerLazySingleton(() => ChatRepository());

  // Register ThemeCubit first
  getIt.registerLazySingleton(() => ThemeCubit());

  // Register AuthCubit using the correct instance of AuthRepository
  getIt.registerLazySingleton(
        () => AuthCubit(authRepository: getIt<AuthRepository>()),
  );

  // Register ChatCubit only if the user is authenticated
  if (getIt<FirebaseAuth>().currentUser != null) {
    getIt.registerFactory(
          () => ChatCubit(
        chatRepository: getIt<ChatRepository>(),
        currentUserId: getIt<FirebaseAuth>().currentUser!.uid,
      ),
    );
  }
}
