import 'package:flutter/material.dart';
import '../widgets/alert_dialog.dart';
import '../utils/constants.dart' as constants;
import '../widgets/admin_list_tile.dart';

class TechnicalAdministratorScreen extends StatefulWidget {
  static const routeName = '/technical-admin';

  const TechnicalAdministratorScreen({super.key});
  @override
  State<TechnicalAdministratorScreen> createState() =>
      _TechnicalAdministrator();
}

class _TechnicalAdministrator extends State<TechnicalAdministratorScreen> {
  late List<Widget> secretariats = List<Widget>.generate(
      10,
      (index) => AdminListTile(
            key: Key(index.toString()),
            index: index + 1,
            callAlert: callAlertScreen,
          ));

  void callAlertScreen(String content, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyAlertDialog(
          text: content,
          removeSecretary: removeSecretry,
          index: index,
        );
      },
    );
  }

  void removeSecretry(int index) {
    setState(() {
      final String key = (index - 1).toString();
      final keyToRemove = Key(key); // Key of the item to remove
      secretariats.removeWhere((item) => item.key == keyToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constants.screenBackgroundColor,
        appBar: AppBar(
          title: Text(
              ModalRoute.of(context)?.settings.arguments as String? ?? 'Admin'),
          actions: [
            IconButton(
                onPressed: () {},
                tooltip: 'Passwort ändern',
                icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: SingleChildScrollView(
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
                for (int i = 0; i < secretariats.length; i++) (secretariats[i])
              ],
            ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Sekretariat hinzufügen',
          child: const Icon(Icons.add),
        ));
  }
}
