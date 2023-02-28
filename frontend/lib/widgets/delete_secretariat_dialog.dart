// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class MyAlertDialog extends StatefulWidget {
  final Function removeSecretary;
  final int index;
  final String name;
  const MyAlertDialog(
      {super.key,
      required this.removeSecretary,
      required this.index,
      required this.name});

  @override
  // ignore: no_logic_in_create_state
  _MyAlertDialogState createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  _MyAlertDialogState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(constants.cPadding),
        actionsAlignment: MainAxisAlignment.end,
        title: Text('${widget.name} löschen'),

        ///+1 um die Anzeige übereinstimmend zu halten
        content: Text('Soll ${widget.name} wirklich gelöscht werden?'),

        ///+1 um die Anzeige übereinstimmend zu halten
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
