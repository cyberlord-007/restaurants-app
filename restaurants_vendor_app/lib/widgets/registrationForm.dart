import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_vendor_app/providers/authProvider.dart';
import 'package:restaurants_vendor_app/screens/home.dart';
import 'package:restaurants_vendor_app/screens/login.dart';
import 'package:restaurants_vendor_app/widgets/inputBox.dart';
import 'package:restaurants_vendor_app/widgets/uiButton.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  var _nameTextcontroller = TextEditingController();
  var _emailTextController = TextEditingController();
  var _passwordController = TextEditingController();
  var _cnfpasswordController = TextEditingController();
  var _addressTextController = TextEditingController();
  String email;
  String password;
  String number;
  String shopName;
  bool _isLoading = false;

  Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    FirebaseStorage firebase_storage = FirebaseStorage.instance;
    try {
      await firebase_storage
          .ref('uploads/shopImages/${_nameTextcontroller.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    String downloadURL = await firebase_storage
        .ref('uploads/shopImages/${_nameTextcontroller.text}')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    scaffoldMessage(msg) {
      return Scaffold.of(context).showSnackBar(SnackBar(content: msg));
    }

    void handleRegistration() {
      if (_authData.isImgAvailable == true) {
        setState(() {
          _isLoading = true;
        });
        if (_formKey.currentState.validate()) {
          _authData.vendorSignUp(email, password).then((credential) {
            if (credential.user.uid != null) {
              uploadFile(_authData.img.path).then((url) {
                if (url != null) {
//                  save vendor info to database
                  _authData
                      .saveVendorData(
                          url: url, shopName: shopName, mobile: number)
                      .then((value) {
                    setState(() {
                      _formKey.currentState.reset();
                      _isLoading = false;
                    });
                  });
                  Navigator.of(context).pushNamed(HomeScreen.id);
                } else {
//                  signup failed
                  scaffoldMessage(_authData.error);
                }
              });
            }
          });
        }
      } else {
        scaffoldMessage('Please add shop image...');
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: _isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
            )
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter shop name...';
                      }
                      setState(() {
                        _nameTextcontroller.text = value;
                        shopName = value;
                      });
                      return null;
                    },
                    decoration: textFieldInputDecoration('Enter your shop name',
                        'Shop Name', Icons.account_balance_outlined),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter mobile number...';
                      }
                      setState(() {
                        number = value;
                      });
                      return null;
                    },
                    decoration: textFieldInputDecoration(
                        'Enter your mobile number...',
                        'Mobile Number',
                        Icons.phone),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter email id...';
                      }
                      setState(() {
                        email = _emailTextController.text;
                      });
                      return null;
                    },
                    decoration: textFieldInputDecoration(
                        'Enter your email id...', 'Email Id', Icons.mail),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Create a password...';
                      }
                      setState(() {
                        password = _passwordController.text;
                      });
                      return null;
                    },
                    decoration: textFieldInputDecoration(
                        'Create a password...', 'Password', Icons.lock),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _cnfpasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Type your password again...';
                      }
                      if (_passwordController.text !=
                          _cnfpasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: textFieldInputDecoration(
                        'Confirm your password...',
                        'Confirm Password',
                        Icons.lock),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _addressTextController,
                    maxLines: 4,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your location...';
                      }
                      if (_authData.shopLatitude == null) {
                        return 'Please press the navigation icon...';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Press the navigator icon to get your location...',
                      hintStyle: TextStyle(color: Colors.black26),
                      labelText: 'Location',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.location_searching,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {
                          _addressTextController.text =
                              'Locating,Please wait...';
                          _authData.getCurrentLocation().then((address) {
                            if (address != null) {
                              setState(() {
                                _addressTextController.text =
                                    '${_authData.placeName}\n${_authData.shopAddress}';
                              });
                            }
                          });
                        },
                      ),
                      labelStyle: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepOrange, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  uiButton(0, 50, 200, 'REGISTER', 30, Colors.deepOrange,
                      handleRegistration),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LogInScreen.id);
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
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
