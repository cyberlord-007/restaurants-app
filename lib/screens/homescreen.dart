import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/providers/authProvider.dart';
import 'package:restaurants_app/providers/locationProvider.dart';
import 'package:restaurants_app/screens/mapscreen.dart';
import 'package:restaurants_app/screens/welcome.dart';
import 'package:restaurants_app/widgets/nearByStores.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _location = '';

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    String location = _sharedPrefs.getString('location');
    setState(() {
      _location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final location = Provider.of<LocationProvider>(context);
    User currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.location,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, MapScreen.id);
          },
        ),
        backgroundColor: Colors.deepOrange,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_location == null ? 'Location not set' : _location),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushReplacementNamed(Welcome.id);
                });
              },
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Material(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search nearby restaurants...',
                  suffixIcon: Icon(
                    CupertinoIcons.search,
                    color: Colors.black54,
                  ),
                  labelStyle: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.deepOrange, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
            ),
            NearByStores()
          ],
        ),
      ),
    );
  }
}
