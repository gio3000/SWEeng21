import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants; //maxInputLength, cPadding

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFieldFocus = FocusNode();
  bool _isTryingToLogin = false; //false if in registration mode
  bool _isLoginSuccessful = false;

  String username = '';
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
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          label: Text('Benutzername'),
                          hintText: 'max-it21@it.dhbw-ravensburg.de',
                        ),
                        validator: _validateUsernameInput,
                        //if finished typing, change focus to password input field
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_passwordFieldFocus),
                      ),
                      const SizedBox(height: 30),

                      //password input field
                      TextFormField(
                        focusNode: _passwordFieldFocus,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text('Passwort'),
                          hintText: 'Passwort hier eingeben',
                        ),
                        validator: _validatePasswordInput,
                      ),
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
                      const SizedBox(height: constants.cPadding),

                      //Registration button
                      _isTryingToLogin
                          ? const SizedBox()
                          : SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  //TODO manage login
                                },
                                child: const Text(
                                  'Du hast noch keinen Account?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
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

    //TODO async await login
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isTryingToLogin = false;
      //TODO check whether login was successful
    });
  }

  ///validates the username text input field syntax
  ///returns the [error message] if syntax is not correct
  ///returns `null` if the syntax is correct
  String? _validateUsernameInput(String? inputValue) {
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

  String? _validatePasswordInput(String? inputValue) {
    inputValue ??= '';
    if (inputValue.length > constants.cMaxInputLength) {
      return 'Zu viele Zeichen!';
    }
    if (inputValue.length < 8) {
      return 'Zu wenige Zeichen!';
    }
    //TODO check for capital letters, numbers and special characters

    return null;
  }
}
