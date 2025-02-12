import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusTile extends StatelessWidget {
  final Map<String, dynamic> status;
  final VoidCallback onDelete;
  final VoidCallback onLoveToggle;
  final bool isMine;

  const StatusTile({
    super.key,
    required this.status,
    required this.onDelete,
    required this.onLoveToggle,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    bool canLove = !isMine;

    // Ensure a fallback if fullName is missing or null
    String displayName = isMine
        ? "My Status"
        : (status.containsKey('fullName') && status['fullName'] != null)
        ? status['fullName']
        : "Unknown Contact";

    return Card(
      color: isMine
          ? Theme.of(context).primaryColor.withOpacity(0.65)
          : Theme.of(context).primaryColor.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(status['status']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName), // Use the checked display name
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.favorite, size: 16, color: Colors.pink),
                const SizedBox(width: 5),
                Text(
                  "${status['loves'].length} Loves",
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canLove)
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: status['loves'].contains(userId) ? Colors.red : Colors.pink.shade50,
                ),
                onPressed: onLoveToggle,
              ),
            if (isMine)
              TextButton(
                child: const Text('Delete'),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
