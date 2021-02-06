import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurants_app/model/User.dart';

class UserService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection('users').doc(id).set(values);
  }

  Future<void> updateUser(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection('users').doc(id).update(values);
  }

  Future<void> fetchUser(String id) async {
    await _firestore.collection('users').doc(id).get().then((doc) {
      if (doc.data() == null) {
        return null;
      } else {
        return User.fromSnapshot(doc);
      }
    });
  }
}
