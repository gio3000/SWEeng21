import 'package:flutter/material.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/authorization_provider.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/screens/secretary_home_screen.dart';
import 'package:frontend/screens/student_screen.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import 'screens/admin_screen.dart';

void main() {
  final user = User(
      id: '', firstName: '', lastName: '', role: UserRole.student, email: '');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthorizationProvider()),
        ChangeNotifierProxyProvider<AuthorizationProvider, User>(
          create: (context) => user,
          update: (context, value, previous) {
            return value.authorizedUser ?? user;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      // home: const LoginScreen(),
      // home: const TechnicalAdministratorScreen(title: 'Startseite'),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        TechnicalAdministratorScreen.routeName: (context) =>
            const TechnicalAdministratorScreen(),
        StudentScreen.routeName: (context) => const StudentScreen(),
        SecretaryHomeScreen.routeName: (context) => const SecretaryHomeScreen(),
      },
    );
  }
}
