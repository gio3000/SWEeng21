import 'package:flutter/material.dart';
import '../widgets/alert_dialog_delete_secretariat.dart';
import '../utils/constants.dart' as constants;
import '../widgets/admin_list_tile.dart';
import '../widgets/add_secretariat_dialog.dart';

class TechnicalAdministratorScreen extends StatefulWidget {
  static const routeName = '/technical-admin';

  const TechnicalAdministratorScreen({super.key});
  @override
  State<TechnicalAdministratorScreen> createState() =>
      _TechnicalAdministrator();
}

class _TechnicalAdministrator extends State<TechnicalAdministratorScreen> {
  Map<int, String> newNames = {};
  Map<int, String> passwords = {};

  ///Map to save index of widget and secretariats name

  ///generates initial List with Secretariats while no database connection exists
  List<String> secretariatsNames =
      List.generate(10, (index) => 'Sekretariat ${index + 1}');

  ///calls AlertDialog if delete button pressed
  void callDeleteAlert(String content, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyAlertDialog(
          removeSecretary: removeSecretariat,
          index: index,
          name: getName(index),
        );
      },
    );
  }

  void addPasswordToMap(int inedx, String password) {
    passwords[inedx] = password;
  }

  String getName(int index) {
    return secretariatsNames[index];
  }

  void callAddDialog(int ind) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddSecretaryDialog(
          index: ind,
          addPassword: addPasswordToMap,
          addSecretariat: addNewNameToMap,
          addToList: addSecretariat,
        );
      },
    );
  }

  ///removes Secretariat from List
  void removeSecretariat(int index) {
    setState(() {
      secretariatsNames.removeAt(index);
    });
  }

  /// add New Seccretariat to List
  void addSecretariat(String name) {
    setState(() {
      secretariatsNames.add(name);
    });
  }

  ///saves index and new name to Map so it can be saved to database from Map
  void addNewNameToMap(int index, String name) {
    newNames[index] = name;
  }

  void changeNameInList(int index, String newName) {
    setState(() {
      secretariatsNames[index] = newName;
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
                    addNewNameToMap: addNewNameToMap,
                    addChangedNameToList: changeNameInList,
                  ),
                  itemCount: secretariatsNames.length,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            callAddDialog((secretariatsNames.length + 1));
            // addSecretariat(
            //     'Sekretariat ${(int.tryParse(secretariatsNames.last.split(' ')[1]) ?? secretariatsNames.length) + 1}');
          },
          tooltip: 'Sekretariat hinzufügen',
          child: const Icon(Icons.add),
        ));
  }
}
