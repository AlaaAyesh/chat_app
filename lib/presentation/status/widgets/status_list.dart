import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repositories/status_repository.dart';
import '../../widgets/status_tile.dart';

class StatusList extends StatelessWidget {
  final List<String> contactIds;

  const StatusList({super.key, required this.contactIds});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: StatusRepository().getStatuses(contactIds),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final statuses = snapshot.data!;
        if (statuses.isEmpty) {
          return const Center(child: Text("No statuses available"));
        }

        String currentUserId = FirebaseAuth.instance.currentUser!.uid;
        List<Map<String, dynamic>> myStatuses = [];
        List<Map<String, dynamic>> contactsStatuses = [];

        for (var status in statuses) {
          if (status['userId'] == currentUserId) {
            myStatuses.add(status);
          } else {
            contactsStatuses.add(status);
          }
        }

        return ListView(
          children: [
            if (myStatuses.isNotEmpty) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Status',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () async {
                        await StatusRepository().deleteAllMyStatuses();
                      },
                      child: const Text(
                        'Delete all',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: myStatuses
                    .map((status) => StatusTile(
                          status: status,
                          isMine: true,
                          onDelete: () =>
                              StatusRepository().deleteStatus(status['id']),
                          onLoveToggle: () {},
                        ))
                    .toList(),
              ),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: const Text(
                  'My Contacts Status ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
            ...contactsStatuses
                .map((status) => StatusTile(
                      status: status,
                      onDelete: () {},
                      onLoveToggle: () => StatusRepository()
                          .toggleLoveStatus(status['id'], status['loves']),
                    ))
                .toList(),
          ],
        );
      },
    );
  }
}
