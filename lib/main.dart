import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DHBW Studierendenverwaltungssystem',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const LoginScreen(),
    );
  }
}
