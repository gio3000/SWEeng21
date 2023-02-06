import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class ChangePassowrd extends StatefulWidget {
  final Function saveNewPassword;
  const ChangePassowrd({super.key, required this.saveNewPassword});

  @override
  State<ChangePassowrd> createState() => _ChangePassowrdState();
}

class _ChangePassowrdState extends State<ChangePassowrd> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordFirstController =
      TextEditingController();
  final TextEditingController _newPasswordSecondController =
      TextEditingController();

  void saveNewPassword() {
    widget.saveNewPassword(_oldPasswordController.text,
        _newPasswordFirstController.text, _newPasswordSecondController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(constants.cPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Passowrt ändern', style: TextStyle(fontSize: 25)),
            TextField(
              maxLength: 60,
              controller: _oldPasswordController,
              decoration: const InputDecoration(
                  hintText: 'Altes Passwort eingeben',
                  label: Text('Altes Password')),
            ),
            TextField(
                controller: _newPasswordFirstController,
                maxLength: 60,
                decoration: const InputDecoration(
                    hintText: 'Neues Passwort eingeben',
                    label: Text('Neues Passwort'))),
            TextField(
              maxLength: 60,
              controller: _newPasswordSecondController,
              decoration: const InputDecoration(
                  hintText: 'Neues Passwort erneut eingeben',
                  label: Text('Neues Passwort')),
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
        ),
      ),
    );
  }
}
