import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/providers/authProvider.dart';
import 'package:restaurants_app/providers/locationProvider.dart';
import 'package:restaurants_app/providers/storeProvider.dart';
import 'package:restaurants_app/screens/homescreen.dart';
import 'package:restaurants_app/screens/login.dart';
import 'package:restaurants_app/screens/mapscreen.dart';
import 'package:restaurants_app/screens/onboarding.dart';
import 'package:restaurants_app/screens/splash.dart';
import 'package:restaurants_app/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => StoreProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        Welcome.id: (context) => Welcome(),
        OnBoarding.id: (context) => OnBoarding(),
        HomeScreen.id: (context) => HomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        LogInScreen.id: (context) => LogInScreen(),
      },
    );
  }
}
