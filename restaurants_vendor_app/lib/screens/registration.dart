import 'package:flutter/material.dart';
import 'package:restaurants_vendor_app/widgets/profileCard.dart';
import 'package:restaurants_vendor_app/widgets/registrationForm.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'register_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[100],
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                ProfileCard(),
                RegistrationForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
