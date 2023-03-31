import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class AddSecretaryDialog extends StatefulWidget {
  final int index;
  final Function addSecretariat;
  const AddSecretaryDialog({
    super.key,
    required this.index,
    required this.addSecretariat,
  });

  @override
  State<AddSecretaryDialog> createState() => AddSecretaryDialogState();
}

class AddSecretaryDialogState extends State<AddSecretaryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  ///calls necessary functions in admin_scrren to save information about new secreiat
  void saveNewSecretariat() {
    widget.addSecretariat(
        _nameController.text, _passwordController.text, _emailController.text);
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Bitte geben Sie eine Email-Adresse ein';
    }
    // The regex pattern for a valid email address
    final RegExp emailRegex = RegExp(r'^[\w-]+.[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Bitte geben Sie eine gültige Email-Adresse ein';
    }
    if (email.length > constants.cMaxInputLength) {
      return 'Die Email-Adresse darf nicht länger als ${constants.cMaxInputLength} Zeichen sein';
    }
    return '';
  }

  String? validatePassword(String? password) {
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
                const Text('Sekretariat hinzufügen',
                    style: TextStyle(fontSize: 25)),
                TextField(
                  maxLength: constants.cMaxInputLength,
                  controller: _nameController,
                  decoration: const InputDecoration(
                      hintText: 'Name des Sekretariats eingeben',
                      label: Text('Name')),
                ),
                TextFormField(
                    controller: _emailController,
                    maxLength: constants.cMaxInputLength,
                    validator: validateEmail,
                    onChanged: (_) => _submitData(),
                    decoration: const InputDecoration(
                        hintText: 'Email-Adresse des Sekretariats eingeben',
                        label: Text('Email-Adresse'))),
                TextFormField(
                    controller: _passwordController,
                    maxLength: constants.cMaxInputLength,
                    validator: validatePassword,
                    onChanged: (_) => _submitData(),
                    decoration: const InputDecoration(
                        hintText:
                            'Initiales Passwort des Sekretariats eingeben',
                        label: Text('Passwort'))),
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
                          saveNewSecretariat();
                        },
                        child: const Text('Speichern'))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
