import 'package:flutter/material.dart';

///in here all global used Constants are stored

//Shared Preferences
const String authTokenSharedPrefKey = '/authorization-token';

//Colors
const Color screenBackgroundColor = Color.fromARGB(255, 211, 211, 211);

//Validating form inputs
const int cMaxInputLength = 60;

//Spaces in design
const double cPadding = 8.0;

//BorderRadius in design
const double cBorderRadius = 8.0;

//Functions

///returns the grade from the percentage count
double percentageToGrade(int percentage) {
  if (percentage < 20) return 5.0;
  if (percentage < 50) return -(5.0 - 4.0) / (50 - 20) + 4.0;
  return -(4.0 - 1.0) / (100 - 50) + 1.0;
}
