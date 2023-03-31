import 'package:flutter/material.dart';
import 'package:frontend/provider/user.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart' as constants;

class ChangePassowrd extends StatefulWidget {
  const ChangePassowrd({super.key});

  @override
  State<ChangePassowrd> createState() => _ChangePassowrdState();
}

class _ChangePassowrdState extends State<ChangePassowrd> {
  ///Controller for old password
  final TextEditingController _oldPasswordController = TextEditingController();

  ///Controller for new password first input
  final TextEditingController _newPasswordFirstController =
      TextEditingController();

  ///Controller for new password second input
  final TextEditingController _newPasswordSecondController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isOldObscurred = true;
  var isFirstNewObscurred = true;
  var isSecondNewObscurred = true;

  ///calls saveNewPasswordMethod from admin_screen
  void saveNewPassword() {
    context.read<User>().changePassword(_oldPasswordController.text,
        _newPasswordFirstController.text, _newPasswordSecondController.text);
  }

  String? validatePasswordOld(String? password) {
    if (password!.isEmpty) {
      return 'Bitte geben Sie ein Passwort ein';
    }
    // password must be 6 characters long, contain one uppercase letter, one lowercase letter and one number
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    if (!passwordRegex.hasMatch(password)) {
      return 'Bitte geben Sie ein gültiges Passwort ein';
    }
    if (password.length > constants.cMaxInputLength) {
      return 'Das Passwort darf nicht länger als ${constants.cMaxInputLength} Zeichen sein';
    }
    return '';
  }

  String? validatePasswordOne(String? password) {
    if (password!.isEmpty) {
      return 'Bitte geben Sie ein Passwort ein';
    }
    // password must be 6 characters long, contain one uppercase letter, one lowercase letter and one number
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    if (!passwordRegex.hasMatch(password)) {
      return 'Bitte geben Sie ein gültiges Passwort ein';
    }
    if (password.length > constants.cMaxInputLength) {
      return 'Das Passwort darf nicht länger als ${constants.cMaxInputLength} Zeichen sein';
    }
    return '';
  }

  String? validatePasswordTwo(String? password) {
    if (password!.isEmpty) {
      return 'Bitte geben Sie ein Passwort ein';
    }
    // password must be 6 characters long, contain one uppercase letter, one lowercase letter and one number
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$');
    if (!passwordRegex.hasMatch(password)) {
      return 'Bitte geben Sie ein gültiges Passwort ein';
    }
    if (password.length > constants.cMaxInputLength) {
      return 'Das Passwort darf nicht länger als ${constants.cMaxInputLength} Zeichen sein';
    }
    return '';
  }

  void _submitData() async {
    //check if inputs are invalid
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(constants.cPadding),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Passowrt ändern', style: TextStyle(fontSize: 25)),
                const Spacer(),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                        child: TextFormField(
                          validator: validatePasswordOld,
                          onChanged: (_) => _submitData(),
                          maxLength: constants.cMaxInputLength,
                          obscureText: isOldObscurred,
                          controller: _oldPasswordController,
                          decoration: const InputDecoration(
                              hintText: 'Altes Passwort eingeben',
                              label: Text('Altes Passwort')),
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isOldObscurred = !isOldObscurred;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                        child: TextFormField(
                            validator: validatePasswordOne,
                            onChanged: (_) => _submitData(),
                            controller: _newPasswordFirstController,
                            maxLength: constants.cMaxInputLength,
                            obscureText: isFirstNewObscurred,
                            decoration: const InputDecoration(
                                hintText: 'Neues Passwort eingeben',
                                label: Text('Neues Passwort')))),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isFirstNewObscurred = !isFirstNewObscurred;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye))
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                        child: TextFormField(
                            validator: validatePasswordTwo,
                            onChanged: (_) => _submitData(),
                            controller: _newPasswordSecondController,
                            maxLength: constants.cMaxInputLength,
                            obscureText: isSecondNewObscurred,
                            decoration: const InputDecoration(
                                hintText: 'Neues Passwort erneut eingeben',
                                label: Text('Neues Passwort')))),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isSecondNewObscurred = !isSecondNewObscurred;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye))
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Abbrechen')),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          saveNewPassword();
                        },
                        child: const Text('Speichern'))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
