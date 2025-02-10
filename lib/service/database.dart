import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

 Future<void> addUser(String name, String email, String phNo) async {
    await _db.collection('user').add({
      "name": name,
      "email": email,
      "phNo": phNo,
      "timeStamp": FieldValue.serverTimestamp(),
    });
  }
  Future<void> updateUser(String userId, String newName, String newEmail, String newPhNo) async {
    try {
      await _db.collection('user').doc(userId).update({
        'name': newName,
        'email': newEmail,
        'phNo': newPhNo,
      });
      print("User updated successfully.");
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _db.collection('user').doc(id).delete();
      print("User deleted successfully.");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<void> deleteAll() async {
    try {
      final QuerySnapshot snapshot = await _db.collection('user').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print("All users deleted successfully.");
    } catch (e) {
      print("Error deleting all users: $e");
    }
  }
  Stream<QuerySnapshot> getUser() {
    return _db.collection('user').orderBy('timeStamp', descending: true).snapshots();
  }
}

