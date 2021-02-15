import '../services/storeService.dart';
import 'package:flutter/cupertino.dart';
import '../services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/welcome.dart';

class StoreProvider with ChangeNotifier {
  StoreService _storeService = StoreService();
  UserService _userService = UserService();
  User user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;

  String getDistance(location) {
    var distance = Geolocator.distanceBetween(
        userLatitude, userLongitude, location.latitude, location.longitude);
    var distInKm = distance / 1000;
    return distInKm.toStringAsFixed(2);
  }

  Future<void> getUserLocationData(context) async {
    _userService.fetchUser(user.uid).then((result) {
      if (user != null) {
        this.userLatitude = result.data()['latitude'];
        this.userLongitude = result.data()['longitude'];
        notifyListeners();
      } else {
        Navigator.pushNamed(context, Welcome.id);
      }
    });
  }
}
