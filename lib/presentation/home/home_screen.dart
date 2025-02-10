import 'package:chat_app/presentation/home/widget/chat_list.dart';
import 'package:chat_app/presentation/home/widget/contacts_button.dart';
import 'package:chat_app/presentation/home/widget/home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeScreenAppBar(),
      body: const ChatList(),
      floatingActionButton: const ContactsButton(),
    );
  }
}




