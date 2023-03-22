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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// TODO add missing parameters to create full user
  ///calls necessary functions in admin_scrren to save information about new secreiat
  void saveNewSecretariat() {
    widget.addSecretariat(_nameController.text, _passwordController.text);
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
            const Text('Sekretariat hinzufügen',
                style: TextStyle(fontSize: 25)),
            TextField(
              maxLength: 60,

              ///TODO Namenslänge festlegen
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: 'Name des Sekretariats eingeben',
                  label: Text('Name')),
            ),
            TextField(
                controller: _passwordController,
                maxLength: 60,

                ///TODO PasswortLänge festelgene
                decoration: const InputDecoration(
                    hintText: 'Initiales Passwort des Sekretariats eingeben',
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
      ),
    );
  }
}
