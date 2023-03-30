import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/authorization_provider.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/screens/admin_screen.dart';
import 'package:frontend/screens/secretary_home_screen.dart';
import 'package:frontend/screens/student_screen.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart' as constants; //maxInputLength, cPadding

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFieldFocus = FocusNode();
  bool _isTryingToLogin = false; //true if loading
  bool _isLoginSuccessful = false;
  int tryLoginCount = 0;

  String email = '';
  String password = '';

  @override
  void dispose() {
    _passwordFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.screenBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SizedBox(
            width: constraints.maxWidth / 2.5,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: constants.cPadding * 2,
                  horizontal: constants.cPadding * 2,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //username input field
                      TextFormField(
                        maxLength: constants.cMaxInputLength,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          label: Text('E-Mail'),
                          hintText: 'max-it21@it.dhbw-ravensburg.de',
                        ),
                        validator: validateUsernameInput,
                        onSaved: (newValue) {
                          setState(() {
                            email = newValue ?? '';
                          });
                        },
                        //if finished typing, change focus to password input field
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_passwordFieldFocus),
                      ),
                      const SizedBox(height: 30),

                      //password input field
                      TextFormField(
                        maxLength: constants.cMaxInputLength,
                        focusNode: _passwordFieldFocus,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text('Passwort'),
                          hintText: 'Passwort hier eingeben',
                        ),
                        onSaved: (newValue) {
                          setState(() {
                            password = newValue ?? '';
                          });
                        },
                        validator: validatePasswordInput,
                        onFieldSubmitted: (_) => _submitData(),
                      ),
                      _isLoginSuccessful == false && tryLoginCount > 0
                          ? Text(
                              'Benutzername oder Passwort sind falsch! Versuche es nocheinmal',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 16,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 50,
                      ),
                      //Login Button
                      _isTryingToLogin
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submitData,
                              child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Einloggen',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///validates given input and stores the given data into `username`
  ///and `password`.
  ///it also sets `_isLoginSuccessful` if login was successful
  void _submitData() async {
    //check if inputs are invalid
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isTryingToLogin = true);

    //authorize user
    await Provider.of<AuthorizationProvider>(context, listen: false)
        .authorize(email, password)
        .then(
          (_) => setState(
            () {
              _isTryingToLogin = false;
              _isLoginSuccessful = true;
            },
          ),
        )
        .catchError((details) {
      debugPrint(details.toString());
      _isTryingToLogin = false;
    });
    setState(() {
      tryLoginCount++;
    });
    if (!mounted) return;
    if (_isLoginSuccessful == false) return;

    //fetch login route
    String loginRoute = '';
    switch (Provider.of<User>(context, listen: false).role) {
      case UserRole.invalid:
        return;
      case UserRole.student:
        loginRoute = StudentScreen.routeName;
        break;
      case UserRole.secretary:
        loginRoute = SecretaryHomeScreen.routeName;
        break;
      case UserRole.lecturer:
        // optional: Handle this case.
        break;
      case UserRole.admin:
        loginRoute = TechnicalAdministratorScreen.routeName;
        break;
    }

    //Move to loginRoute
    Navigator.of(context).pushReplacementNamed(loginRoute);
  }

  ///validates the username text input field syntax
  ///returns the [error message] if syntax is not correct
  ///returns `null` if the syntax is correct
  String? validateUsernameInput(String? inputValue) {
    inputValue ??= ''; // if inputValue is null set to empty string

    //check for max length
    if (inputValue.length > constants.cMaxInputLength) {
      return 'Zu viele Zeichen!';
    }

    if (inputValue.isEmpty) {
      return 'Vergiss nicht den Benutzernamen einzugeben!';
    }
    return null;
  }

  ///validates the password text input field syntax
  ///returns the [error message] if syntax is not correct
  ///returns `null` if the syntax is correct
  String? validatePasswordInput(String? inputValue) {
    inputValue ??= '';
    if (inputValue.length > constants.cMaxInputLength) {
      return 'Zu viele Zeichen!';
    }
    if (inputValue.length < 6) {
      return 'Zu wenige Zeichen!';
    }
    if (!inputValue.contains(RegExp(r"[A-Z]"))) {
      return 'Mindestens ein Großbuchstabe soll enthalten sein';
    }
    if (!inputValue.contains(RegExp(r"[a-z]"))) {
      return 'Mindestens ein Kleinbuchstabe soll enthalten sein';
    }
    if (!inputValue.contains(RegExp(r"[0-9]"))) {
      return 'Mindestens eine Zahl soll enthalten sein';
    }

    return null;
  }
}
