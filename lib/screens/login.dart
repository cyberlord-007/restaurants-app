import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/providers/authProvider.dart';
import 'package:restaurants_app/providers/locationProvider.dart';
import 'package:restaurants_app/screens/homescreen.dart';
import 'package:restaurants_app/screens/mapscreen.dart';
import 'package:restaurants_app/widgets/uiButton.dart';

import '../constants.dart';

class LogInScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  var _phoneNumberController = TextEditingController();

  bool isValid = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final location = Provider.of<LocationProvider>(context);

    void handleSubmit() {
      String number = '+91${_phoneNumberController.text}';
      auth
          .verifyPhone(
              context: context,
              number: number,
              latitude: location.latitude,
              longitude: location.longitude,
              address: location.selectedAddress.addressLine)
          .then((value) {
        _phoneNumberController.clear();
      });
      Navigator.of(context).pushNamed(HomeScreen.id);
    }

    void handleLocation() async {
      await location.getCurrentLocation();
      if (location.isAllowed == true) {
        Navigator.of(context).pushReplacementNamed(MapScreen.id);
      } else {
        print('Permission not allowed');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Visibility(
                  visible: auth.error == 'Invalid OTP' ? true : false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(auth.error),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                Text(
                  'LOG IN',
                  style: kOnboardingTextStyle,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _phoneNumberController,
                  onChanged: (value) {
                    if (value.length == 10) {
                      setState(() {
                        isValid = true;
                      });
                    } else {
                      setState(() {
                        isValid = false;
                      });
                    }
                  },
                  keyboardType: TextInputType.phone,
                  decoration: TextFieldDecoration('10 digit phone number...',
                      'Phone Number', Icons.add_call),
                  maxLength: 10,
                ),
                uiButton(
                    8, 50, 180, 'CONTINUE', 30, Colors.deepOrange, handleSubmit)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
