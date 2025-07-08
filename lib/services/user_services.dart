import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list_app/models/app_user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser?> getUser(String id) async {
    final doc = await _db.collection("users").doc(id).get();

    if (doc.exists) {
      return AppUser.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }

  Stream<List<AppUser>> getUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => AppUser.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }

  Future<void> setUser(AppUser user) {
    return _db.collection('users').doc(user.id).set(user.toFirestore());
  }
}
