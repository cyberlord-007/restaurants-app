import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurants_app/constants.dart';
import 'package:restaurants_app/providers/locationProvider.dart';
import 'package:restaurants_app/screens/homescreen.dart';
import 'package:restaurants_app/screens/mapscreen.dart';
import 'package:restaurants_app/screens/onboarding.dart';
import 'package:restaurants_app/widgets/uiButton.dart';
import 'package:provider/provider.dart';
import '../providers/authProvider.dart';

class Welcome extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final location = Provider.of<LocationProvider>(context, listen: false);

    var _phoneNumberController = TextEditingController();

    bool isValid = false;

    void handleSubmit() {
      auth.loading = true;
      String number = '+91${_phoneNumberController.text}';
      auth.verifyPhone(context: context, number: number).then((value) {
        _phoneNumberController.clear();
        auth.loading = false;
      });
    }

    void handleLocation() async {
      await location.getCurrentLocation();
      if (location.isAllowed == true) {
        Navigator.of(context).pushReplacementNamed(MapScreen.id);
      } else {
        print('Permission not allowed');
      }
    }

    void showBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (context) =>
              StatefulBuilder(builder: (context, StateSetter myState) {
                return Container(
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
                              isValid = true;
                            } else {
                              isValid = false;
                            }
                          },
                          keyboardType: TextInputType.phone,
                          decoration: TextFieldDecoration(
                              '10 digit phone number...',
                              'Phone Number',
                              Icons.add_call),
                          maxLength: 10,
                        ),
                        uiButton(8, 50, 180, 'CONTINUE', 30, Colors.deepOrange,
                            handleSubmit)
                      ],
                    ),
                  ),
                );
              }));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(child: OnBoarding()),
            SizedBox(height: 10),
            Text('Ready to serve your hunger...'),
            SizedBox(height: 20),
            uiButton(8, 50, 180, 'Set Location', 30, Colors.deepOrange,
                handleLocation),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?  '),
                GestureDetector(
                  onTap: () {
                    showBottomSheet(context);
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
