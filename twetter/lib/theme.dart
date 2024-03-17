import 'package:flutter/material.dart';

const primaryColor = Color(0xFF6200EE);
const secondaryColor = Color(0xFF03DAC6);
const backgroundColor = Color(0xFFF5F5F5);
const textColor = Color(0xFF333333);

final lightTheme = ThemeData(
  primaryColor: primaryColor,
  splashColor: secondaryColor,
  scaffoldBackgroundColor: backgroundColor,
  textTheme: TextTheme(
    bodyText1: TextStyle(color: textColor),
    bodyText2: TextStyle(color: textColor.withOpacity(0.6)),
  ),
);

final darkTheme = ThemeData(
  primaryColor: secondaryColor,
  splashColor: primaryColor,
  scaffoldBackgroundColor: Color(0xFF333333),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white70),
  ),
);
