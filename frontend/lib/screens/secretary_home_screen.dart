import 'package:flutter/material.dart';
import 'package:frontend/provider/authorization_provider.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/secretary/secretary_courses_screen.dart';
import 'package:frontend/screens/secretary/secretary_grade_input_screen.dart';
import 'package:frontend/screens/secretary/secretary_grade_overview_screen.dart';
import 'package:frontend/screens/secretary/secretary_lecturer_screen.dart';
import 'package:frontend/widgets/change_password.dart';
import 'package:provider/provider.dart';

class SecretaryHomeScreen extends StatefulWidget {
  static const routeName = '/secretary';
  const SecretaryHomeScreen({super.key});

  @override
  State<SecretaryHomeScreen> createState() => _SecretaryHomeScreenState();
}

class _SecretaryHomeScreenState extends State<SecretaryHomeScreen> {
  final List<Widget> tabWidgets = [
    const SecretaryCoursesScreen(),
    const SecretaryLecturerScreen(),
    const SecretaryGradeOverviewScreen(),
    const SecretaryGradeInputScreen(),
  ];
  int currentWidgetIndex = 0;

  static const _passwordChangeValue = 'password';
  static const _logoutValue = 'logout';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: currentWidgetIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sekretariat'),
          bottom: TabBar(
              onTap: (value) => setState(() {
                    currentWidgetIndex = value;
                  }),
              tabs: const [
                Tab(
                  child: Text('Kurse'),
                ),
                Tab(
                  child: Text('Dozenten'),
                ),
                Tab(
                  child: Text('Notenübersicht'),
                ),
                Tab(
                  child: Text('Noten eintragen'),
                ),
              ]),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case _logoutValue:
                    Provider.of<AuthorizationProvider>(context, listen: false)
                        .logout();
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                    break;
                  case _passwordChangeValue:
                    showDialog(
                        context: context,
                        builder: (context) =>
                            ChangePassowrd(saveNewPassword: () {
                              //TODO
                            }));
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _passwordChangeValue,
                  child: Text('Passwort ändern'),
                ),
                const PopupMenuItem(
                  value: _logoutValue,
                  child: Text('Abmelden'),
                ),
              ],
            )
          ],
        ),
        body: tabWidgets[currentWidgetIndex],
      ),
    );
  }
}
