import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> postStatus(String statusText, List<String> contactIds) async {
    if (statusText.isEmpty) return;

    String userId = _auth.currentUser!.uid;
    DateTime timestamp = DateTime.now();
    DateTime expiryTime = timestamp.add(const Duration(hours: 24));

    try {
      // Fetch user name from Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userId).get();
      String fullName = userDoc.exists ? (userDoc['fullName'] ?? "Unknown") : "Unknown";

      // Save status with full name
      await _firestore.collection('statuses').add({
        'userId': userId,
        'fullName': fullName, // Store user's name
        'status': statusText,
        'timestamp': timestamp.toIso8601String(),
        'expiryTime': expiryTime.toIso8601String(),
        'sharedWith': contactIds,
        'loves': [],
      });
    } catch (e) {
      print("Error posting status: $e");
    }
  }

  Future<void> toggleLoveStatus(String statusId, List<dynamic> loves) async {
    String userId = _auth.currentUser!.uid;
    final statusRef = _firestore.collection('statuses').doc(statusId);

    if (loves.contains(userId)) {
      await statusRef.update({'loves': FieldValue.arrayRemove([userId])});
    } else {
      await statusRef.update({'loves': FieldValue.arrayUnion([userId])});
    }
  }

  Future<void> deleteStatus(String statusId) async {
    await _firestore.collection('statuses').doc(statusId).delete();
  }

  Future<void> deleteAllMyStatuses() async {
    String userId = _auth.currentUser!.uid;
    var myStatuses = await _firestore
        .collection('statuses')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in myStatuses.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<Map<String, dynamic>>> getStatuses(List<String> contactIds) {
    String userId = _auth.currentUser!.uid;
    DateTime now = DateTime.now();

    return _firestore.collection('statuses').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'userId': data['userId'],
          'fullName': data['fullName'] ?? "Unknown", // Ensure fullName is available
          'status': data['status'],
          'timestamp': DateTime.parse(data['timestamp']),
          'expiryTime': DateTime.parse(data['expiryTime']),
          'loves': List<String>.from(data['loves'] ?? []),
        };
      })
          .where((status) =>
      status['expiryTime'].isAfter(now) &&
          (status['userId'] == userId || contactIds.contains(status['userId'])))
          .toList();
    });
  }
}
