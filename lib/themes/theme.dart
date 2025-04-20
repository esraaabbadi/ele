import 'package:flutter/material.dart';

TextTheme generalTheme = const TextTheme(
  titleLarge: TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "bold",
  ),
  titleMedium: TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: "medium",
  ),
  titleSmall: TextStyle(
    fontWeight: FontWeight.w300,
    fontFamily: "light",
    color: Color(0xFF615E5E),
  ),
  bodyLarge: TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "bold",
    color: Colors.white,
  ),
  bodyMedium: TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: "medium",
    color: Colors.white,
  ),
  bodySmall: TextStyle(
    fontWeight: FontWeight.w300,
    fontFamily: "light",
    color: Colors.white,
  ),
  displayLarge: TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "bold",
    fontSize: 24,
    color: Colors.black,
  ),
  displaySmall: TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: "light",
    color: Colors.white,
  ),
  displayMedium: TextStyle(
    fontWeight: FontWeight.w300,
    fontFamily: "medium",
    fontSize: 14,
    color: Colors.black,
  ),
);
