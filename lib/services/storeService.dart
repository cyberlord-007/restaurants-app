import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  getNearByStores() {
    return FirebaseFirestore.instance.collection('vendors').snapshots();
  }

  getNearByStoresPagination() {
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .orderBy('shopName');
  }
}
