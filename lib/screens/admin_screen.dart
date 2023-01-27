import 'package:flutter/material.dart';
import '../widgets/alert_dialog.dart';
import '../utils/constants.dart' as constants;
import '../widgets/admin_list_tile.dart';

class TechnicalAdministratorScreen extends StatefulWidget {
  const TechnicalAdministratorScreen({super.key, required this.title});
  final String title;
  @override
  State<TechnicalAdministratorScreen> createState() =>
      _TechnicalAdministrator();
}

class _TechnicalAdministrator extends State<TechnicalAdministratorScreen> {
  late List<Widget> secretarys = List<Widget>.generate(
      10,
      (index) => AdminListTile(
            index: index + 1,
            callAlert: callAlertScreen,
            changeExpansion: changeExpansion,
          ));

  void callAlertScreen(String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyAlertDialog(
          text: content,
        );
      },
    );
  }

  bool changeExpansion(bool expanded) {
    setState(() {
      expanded = !expanded;
    });
    return expanded;
  }

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
                for (int i = 0; i < secretarys.length; i++) (secretarys[i])
              ],
            ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Sekretariat hinzufügen',
          child: const Icon(Icons.add),
        ));
  }
}
