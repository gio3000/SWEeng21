import 'package:flutter/material.dart';
import '../widgets/alert_dialog_delete_secretariat.dart';
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
  Map<int, String> newNames = {};
  int key = 10;

  ///Map to save index of widget and secretariats name

  ///generates initial List with Secretariats while no database connection exists
  List<String> secretariatsNames =
      List.generate(10, (index) => 'Sekretariat ${index + 1}');
  // late List<Widget> secretariats = List<Widget>.generate(
  //     10,
  //     (index) => AdminListTile(
  //           key: ValueKey(index),
  //           index: index + 1,
  //           callAlert: callDeleteAlert,
  //           name: 'Sekretariat ${index + 1}',
  //           addNewNameToMap: addNewNameToMap,
  //         ));

  ///calls AlertDialog if delete button pressed
  void callDeleteAlert(String content, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyAlertDialog(
          text: content,
          removeSecretary: removeSecretariat,
          index: index,
        );
      },
    );
  }

  ///removes Secretariat from List
  void removeSecretariat(int index) {
    debugPrint('$index , max: ${secretariatsNames.length}');
    setState(() {
      secretariatsNames.removeAt(index);
      // final int key = index - 1;
      // final keyToRemove = ValueKey(key);
      // secretariats.removeWhere((item) => item.key == keyToRemove);
    });
  }

  /// add New Seccretariat to List
  void addSecretariat(String name) {
    setState(() {
      secretariatsNames.add(name);
      // int newIndex = secretariats.length;
      // AdminListTile newSec = AdminListTile(
      //     key: Key(newIndex.toString()),
      //     index: key + 1,
      //     callAlert: callDeleteAlert,
      //     name: 'Sekretariat ${key + 1}',
      //     addNewNameToMap: addNewNameToMap);
      // secretariats.add(newSec);
      // key++;
    });
  }

  ///saves index and new name to Map so it can be saved to database from Map
  void addNewNameToMap(int index, String name) {
    newNames[index] = name;
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
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => AdminListTile(
                      key: UniqueKey(),
                      index: index,
                      callAlert: callDeleteAlert,
                      name: secretariatsNames[index],
                      addNewNameToMap: addNewNameToMap),
                  itemCount: secretariatsNames.length,
                ),
              ),
              // for (int i = 0; i < secretariats.length; i++) (secretariats[i])
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addSecretariat(
                'Sekretariat ${(int.tryParse(secretariatsNames.last.split(' ')[1]) ?? secretariatsNames.length) + 1}');
          },
          tooltip: 'Sekretariat hinzufügen',
          child: const Icon(Icons.add),
        ));
  }
}
