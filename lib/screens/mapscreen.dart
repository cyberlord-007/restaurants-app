import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/constants.dart';
import 'package:restaurants_app/providers/authProvider.dart';
import 'package:restaurants_app/providers/locationProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:restaurants_app/screens/login.dart';
import 'package:restaurants_app/widgets/uiButton.dart';

import 'homescreen.dart';

class MapScreen extends StatefulWidget {
  static String id = 'map_screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation;
  bool logggedIn = false;
  User currentUser;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
    if (currentUser != null) {
      setState(() {
        logggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    GoogleMapController _mapController;

    setState(() {
      currentLocation = LatLng(location.latitude, location.longitude);
    });

    void onMapCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    void confirmLocation() {
      location.savePrefs();
      if (logggedIn == false) {
        Navigator.of(context).pushNamed(LogInScreen.id);
      } else {
        auth.updateUser(
            id: currentUser.uid,
            number: currentUser.phoneNumber,
            latitude: location.latitude,
            longitude: location.longitude,
            address: location.selectedAddress.addressLine);
        Navigator.of(context).pushNamed(HomeScreen.id);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.4746,
              ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              onCameraMove: (CameraPosition position) {
                location.onCameraMove(position);
              },
              onMapCreated: onMapCreated,
              onCameraIdle: () {
                location.moveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset('./assets/marker.png'),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.add_location,
                              color: Colors.black54, size: 20),
                          SizedBox(width: 5),
                          Text(
                            location.selectedAddress.featureName,
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(location.selectedAddress.addressLine,
                          style: TextStyle(fontSize: 15)),
                      SizedBox(
                        height: 10,
                      ),
                      uiButton(
                          0,
                          50,
                          MediaQuery.of(context).size.width,
                          'CONFIRM LOCATION',
                          30,
                          Colors.deepOrange,
                          confirmLocation),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
