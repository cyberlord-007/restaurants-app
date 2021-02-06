import 'package:flutter/material.dart';
import 'package:restaurants_app/constants.dart';
import 'package:restaurants_app/screens/onboarding.dart';
import 'package:restaurants_app/widgets/uiButton.dart';

class Welcome extends StatelessWidget {
  bool isValid = false;

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
                      Text(
                        'LOG IN',
                        style: kOnboardingTextStyle,
                      ),
                      SizedBox(height: 20),
                      TextField(
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

  void handleSubmit() {}

  @override
  Widget build(BuildContext context) {
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
                handleSubmit),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
