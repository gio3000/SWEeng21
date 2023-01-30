// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class MyAlertDialog extends StatefulWidget {
  final String text;
  final Function removeSecretary;
  final int index;
  const MyAlertDialog(
      {super.key,
      required this.text,
      required this.removeSecretary,
      required this.index});

  @override
  // ignore: no_logic_in_create_state
  _MyAlertDialogState createState() => _MyAlertDialogState(text);
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final String text;
  _MyAlertDialogState(this.text);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(constants.cPadding),
        actionsAlignment: MainAxisAlignment.end,
        title: Text('$text löschen'),
        content: Text('Soll $text wirklich gelöscht werden?'),
        actions: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen')),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.removeSecretary(widget.index);
                  },
                  child: const Text('Bestätigen'))
            ],
          )
        ]);
  }
}
