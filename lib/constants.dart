import 'package:flutter/material.dart';

const kOnboardingTextStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const kAPIKEY = 'AIzaSyBjSiK1Y8ngeH2wQhkZ8QNucplbvGk6Fyg';

const kNearByCardText =
    TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);

InputDecoration TextFieldDecoration(
    String hintText, String labelText, IconData iconType) {
  return InputDecoration(
      prefixText: '+91  ',
      prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black26),
      labelText: labelText,
      suffixIcon: Icon(
        iconType,
        color: Colors.deepOrange,
      ),
      labelStyle: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Colors.deepOrangeAccent),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ));
}
