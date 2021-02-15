import 'package:flutter/material.dart';

Material uiButton(double elevation, double minHeight, double minWidth,
    String buttonText, double radius, Color color, Function setData) {
  return Material(
    elevation: elevation,
    color: color,
    shadowColor: Colors.black45,
    borderRadius: BorderRadius.circular(radius),
    child: MaterialButton(
      onPressed: setData,
      minWidth: minWidth,
      height: minHeight,
      child: Text(buttonText, style: TextStyle(color: Colors.white)),
    ),
  );
}
