import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static const NUMBER = 'number';
  static const ID = 'id';

  String _number;
  String _id;

  String get number => _number;
  String get id => _id;

  User.fromSnapshot(DocumentSnapshot snapshot) {
    _number = snapshot.data()[NUMBER];
    _id = snapshot.data()[ID];
  }
}
