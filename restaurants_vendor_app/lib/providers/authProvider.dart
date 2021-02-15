import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoder/geocoder.dart';

class AuthProvider with ChangeNotifier {
  File img;
  String pickError;
  bool isImgAvailable = false;
  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String placeName;
  String email;
  String error = '';

  final picker = ImagePicker();
  Future<File> getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      this.img = File(pickedImage.path);
      notifyListeners();
    } else {
      this.pickError = 'No image selected';
      print('No image selected');
    }
    return this.img;
  }

  Future getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    this.shopLatitude = _locationData.latitude;
    this.shopLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var _shopAddress = _addresses.first;
    this.shopAddress = _shopAddress.addressLine;
    this.placeName = _shopAddress.featureName;
    notifyListeners();
    return _shopAddress;
  }

  Future<UserCredential> vendorSignUp(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
      } else if (err.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    return userCredential;
  }

  Future<void> saveVendorData({String url, String shopName, String mobile}) {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user.uid);
    _vendors.set({
      'uid': user.uid,
      'shopName': shopName,
      'url': url,
      'mobile': mobile,
      'email': this.email,
      'address': this.shopAddress,
      'location': GeoPoint(this.shopLatitude, this.shopLongitude),
      'isTopPicked': true,
      'accVerified': true,
    });
    return null;
  }

  Future<UserCredential> vendorSignIn(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
      } else if (err.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    return userCredential;
  }
}
