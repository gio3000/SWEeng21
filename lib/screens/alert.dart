// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

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
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Sekretariat löschen',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child:
                  Text('Möchten sie das Sekretariat $text wirklich löschen?'),
            ),
            Expanded(
              child: Row(children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen'),
                ),
                const SizedBox(
                  width: 97,
                ),
                ElevatedButton(
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
