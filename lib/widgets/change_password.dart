import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class ChangePassowrd extends StatefulWidget {
  final Function saveNewPassword;
  const ChangePassowrd({super.key, required this.saveNewPassword});

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

  var isOldObscurred = true;
  var isFirstNewObscurred = true;
  var isSecondNewObscurred = true;

  ///calls saveNewPasswordMethod from admin_screen
  void saveNewPassword() {
    widget.saveNewPassword(_oldPasswordController.text,
        _newPasswordFirstController.text, _newPasswordSecondController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.35,
        padding: const EdgeInsets.all(constants.cPadding),
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
                    child: TextField(
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
                    child: TextField(
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
                    child: TextField(
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
        ),
      ),
    );
  }
}
