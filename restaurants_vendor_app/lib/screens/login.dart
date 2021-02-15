import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_vendor_app/providers/authProvider.dart';
import 'package:restaurants_vendor_app/screens/home.dart';
import 'package:restaurants_vendor_app/widgets/inputBox.dart';
import 'package:restaurants_vendor_app/widgets/uiButton.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordController = TextEditingController();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    void logInUser() {
      if (_formKey.currentState.validate()) {
        _authData.vendorSignIn(email, password).then((credential) {
          if (credential.user.uid != null) {
            Navigator.pushNamed(context, HomeScreen.id);
          }
        });
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Login Failed!')));
      }
    }

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Spacer(),
              Center(
                child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Image.asset('./assets/avatar.png')),
              ),
              Text(
                'LOG IN',
                style: GoogleFonts.kanit(fontSize: 40),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailTextController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  }
                  setState(() {
                    email = _emailTextController.text;
                  });
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: textFieldInputDecoration(
                    'Enter your email...', 'Email', Icons.mail),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your password';
                  }
                  if (value.length < 6) {
                    return 'Minimum 6 characters required';
                  }
                  setState(() {
                    password = value;
                  });
                  return null;
                },
                controller: _passwordController,
                obscureText: true,
                decoration: textFieldInputDecoration(
                    'Type your password...', 'Password', Icons.lock),
              ),
              SizedBox(
                height: 20,
              ),
              uiButton(0, 50, 200, 'LOG IN', 30, Colors.deepOrange, logInUser),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
