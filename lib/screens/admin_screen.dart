import 'package:flutter/material.dart';
import '../widgets/alert_dialog.dart';
import '../utils/constants.dart' as constants;

class TechnicalAdministratorScreen extends StatefulWidget {
  const TechnicalAdministratorScreen({super.key, required this.title});
  final String title;
  @override
  State<TechnicalAdministratorScreen> createState() =>
      _TechnicalAdministrator();
}

class _TechnicalAdministrator extends State<TechnicalAdministratorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constants.screenBackgroundColor,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {},
                tooltip: 'Passwort ändern',
                icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Column(
              children: [
                const Text(
                  'Sekretariate',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  thickness: 5,
                ),
                for (int i = 1; i < 8; i++)
                  (Column(
                    children: [
                      Row(
                        children: [
                          Text('Sekretariat $i'),
                          const SizedBox(
                            width: 1000,
                          ),
                          IconButton(
                              onPressed: () {},
                              tooltip: 'Sekretariat bearbeiten',
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black54,
                              )),
                          const SizedBox(
                            width: 25,
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return MyAlertDialog(
                                      text: 'Sektretariat $i',
                                    );
                                  },
                                );
                              },
                              tooltip: 'Sekretariat entfernen',
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                      const Divider(
                        thickness: 5,
                      )
                    ],
                  ))
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Sekretariat hinzufügen',
          child: const Icon(Icons.add),
        ));
  }
}
