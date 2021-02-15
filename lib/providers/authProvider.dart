import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:restaurants_app/constants.dart';
import 'package:restaurants_app/providers/locationProvider.dart';
import 'package:restaurants_app/screens/homescreen.dart';
import 'package:restaurants_app/services/userService.dart';
import 'package:restaurants_app/widgets/uiButton.dart';

class AuthProvider with ChangeNotifier {
  String OTP;
  String verificationId;
  String error = '';
  bool loading = false;

  UserService _userService = UserService();

  FirebaseAuth _auth = FirebaseAuth.instance;
  LocationProvider location = LocationProvider();

  Future<bool> otpDialog(BuildContext context, String number, double latitude,
      double longitude, String address) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('OTP VERIFICATION', style: kOnboardingTextStyle),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    this.OTP = value;
                  },
                ),
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: OTP);
                      final User loggedinUser = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user;
//                      create user in the database after verification
                      if (location.selectedAddress != null) {
                        updateUser(
                            id: loggedinUser.uid,
                            number: loggedinUser.phoneNumber,
                            latitude: location.latitude,
                            longitude: location.longitude,
                            address: location.selectedAddress.addressLine);
                      } else {
                        _createUser(
                            id: loggedinUser.uid,
                            number: loggedinUser.phoneNumber,
                            latitude: latitude,
                            longitude: longitude,
                            address: address);
                      }

                      if (loggedinUser != null) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(HomeScreen.id);
                      } else {
                        print('login failed');
                      }
                    } catch (err) {
                      this.error = 'Invalid OTP';
                      notifyListeners();
                      print(err.toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'VERIFY',
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  )),
            ],
          );
        });
  }

  Future<void> verifyPhone(
      {BuildContext context,
      String number,
      double latitude,
      double longitude,
      String address}) async {
    this.loading = true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException err) {
      print(err.code);
      this.error = err.toString();
      notifyListeners();
    };

    final PhoneCodeSent otpVerification =
        (String verifyId, int resendToken) async {
      this.verificationId = verifyId;
      otpDialog(context, number, latitude, longitude, address);
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: otpVerification,
        codeAutoRetrievalTimeout: (String verifyId) {
          this.verificationId = verifyId;
        },
      );
    } catch (err) {
      this.error = err.toString();
      notifyListeners();
    }
  }

  void _createUser(
      {String id,
      String number,
      double latitude,
      double longitude,
      String address}) {
    _userService.createUser({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address
    });
    notifyListeners();
  }

  void updateUser(
      {String id,
      String number,
      double latitude,
      double longitude,
      String address}) {
    _userService.updateUser({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address
    });
    notifyListeners();
  }
}
