import 'package:chat_app/presentation/status/widgets/status_input.dart';
import 'package:chat_app/presentation/status/widgets/status_list.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/contact_repository.dart';
import '../../../data/services/service_locator.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final ContactRepository _contactRepository = getIt<ContactRepository>();
  List<String> _contactIds = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await _contactRepository.getRegisteredContacts();
    setState(() {
      _contactIds = contacts.map((c) => c['id'].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatusInput(contactIds: _contactIds),  // Pass contactIds
            const SizedBox(height: 16),
            Expanded(child: StatusList(contactIds: _contactIds)), // Pass contactIds
          ],
        ),
      ),
    );
  }
}
