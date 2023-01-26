// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class MyAlertDialog extends StatefulWidget {
  final String text;
  const MyAlertDialog({super.key, required this.text});

  @override
  // ignore: no_logic_in_create_state
  _MyAlertDialogState createState() => _MyAlertDialogState(text);
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final String text;
  _MyAlertDialogState(this.text);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: const EdgeInsets.all(constants.cPadding),
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: const EdgeInsets.all(constants.cPadding),
              child: Text(
                'Sekretariat löschen',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(constants.cPadding),
              child:
                  Text('Möchten sie das Sekretariat $text wirklich löschen?'),
            ),
            Expanded(
              child: Row(children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen'),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Bestätigen'),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
