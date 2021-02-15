import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurants_app/screens/homescreen.dart';
import 'package:restaurants_app/screens/welcome.dart';
import 'package:restaurants_app/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.of(context).pushNamed(Welcome.id);
        } else {
          getUserData();
          Navigator.of(context).pushNamed(HomeScreen.id);
        }
      });
    });
    super.initState();
  }

  getUserData() async {
    UserService _userServices = UserService();
    _userServices.fetchUser(user.uid).then((result) {
      if (result.data()['address'] != null) {
        updatePrefs(result);
      }
      Navigator.pushNamed(context, HomeScreen.id);
    });
  }

  Future<void> updatePrefs(result) async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    _sharedPrefs.setDouble('latitude', result['latitude']);
    _sharedPrefs.setDouble('longitude', result['longitude']);
    _sharedPrefs.setString('address', result['address']);
    _sharedPrefs.setString('location', result['location']);
    Navigator.pushNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('./assets/splash.png'),
          Text(
            'Door Delights',
            style: GoogleFonts.courgette(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.deepOrange),
          )
        ],
      ),
    );
  }
}
