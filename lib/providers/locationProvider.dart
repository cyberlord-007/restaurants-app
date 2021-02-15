import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude;
  double longitude;
  bool isAllowed = false;

  var selectedAddress;

  Future<void> getCurrentLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (pos != null) {
      this.latitude = pos.latitude;
      this.longitude = pos.longitude;
      final coordinates = new Coordinates(this.latitude, this.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selectedAddress = addresses.first;
      this.isAllowed = true;
      notifyListeners();
    } else {
      print('permission not granted');
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;

    notifyListeners();
  }

  Future<void> moveCamera() async {
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = addresses.first;
    print('${selectedAddress.featureName} : ${selectedAddress.addressLine}');
  }

  Future<void> savePrefs() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    _sharedPrefs.setDouble('latitude', this.latitude);
    _sharedPrefs.setDouble('longitude', this.longitude);
    _sharedPrefs.setString('address', this.selectedAddress.addressLine);
    _sharedPrefs.setString('location', this.selectedAddress.featureName);
  }
}
