import 'package:flutter/material.dart';
import 'package:frontend/utils/authenticated_request.dart';
import 'package:provider/provider.dart';
import '../models/admin_user.dart';
import '../provider/user.dart';
import '../widgets/delete_secretariat_dialog.dart';
import '../utils/constants.dart' as constants;
import '../widgets/admin_list_tile.dart';
import '../widgets/add_secretariat_dialog.dart';
import '../widgets/change_password.dart';

class TechnicalAdministratorScreen extends StatefulWidget {
  static const routeName = '/technical-admin';

  const TechnicalAdministratorScreen({super.key});
  @override
  State<TechnicalAdministratorScreen> createState() =>
      _TechnicalAdministrator();
}

class _TechnicalAdministrator extends State<TechnicalAdministratorScreen> {
  ///Map to save index of widget and secretariats name
  Map<int, String> newNames = {};

  ///Map to save index of widget and secretariats password
  Map<int, String> passwords = {};

  ///String to save the new Password
  late String newPassword;

  ///List with secretariats which passwords have been reseted
  List<int> secretaryWithResetedPassword = [];

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
          name: secretariatsNames[index],
        );
      },
    );
  }

  void getSecretaris() async {
    Future<List<String>> futureSecretarys =
        (Provider.of<User>(context, listen: false) as Admin).getSecretaries();
    List<String> secretaries = await futureSecretarys;
    secretariatsNames.clear();
    setState(() {
      secretariatsNames = secretaries;
    });
  }

  ///calls Dialog to change Password
  void callChangePasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ChangePassowrd();
      },
    );
  }

  @override
  void initState() {
    getSecretaris();
    super.initState();
  }

  ///opens the Dialog-Window to add new secretariat
  void callAddDialog(int ind) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddSecretaryDialog(
          index: ind,
          addSecretariat: addSecretariat,
        );
      },
    );
  }

  ///removes Secretariat from List
  void removeSecretariat(int index) {
    (Provider.of<User>(context, listen: false) as Admin)
        .deleteSecretary(name: secretariatsNames[index]);
  }

  /// add New Seccretariat to List
  void addSecretariat(String name, String password) {
    (Provider.of<User>(context, listen: false) as Admin)
        .addSecretary(name: name, password: password);
  }

  ///saves index and new name to Map so it can be saved to database from Map
  void addNewNameToMap(int index, String name) {
    newNames[index] = name;
  }

  ///updates name in list when name changed
  void changeNameInList(int index, String newName) {
    if (index >= 0 && index < secretariatsNames.length) {
      (Provider.of<User>(context, listen: false) as Admin).changeSecretaryName(
          oldName: secretariatsNames[index], newName: newName);
    }
  }

  ///adds index of secretariat to List so it can be pushed to Database
  void resetPassword(int index) {
    (Provider.of<User>(context, listen: false) as Admin)
        .resetSecretaryPassword(name: secretariatsNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    var _ = Provider.of<User>(context);
    return Scaffold(
        backgroundColor: constants.screenBackgroundColor,
        appBar: AppBar(
          title: Text(
              ModalRoute.of(context)?.settings.arguments as String? ?? 'Admin'),
          actions: [
            IconButton(
                onPressed: () {
                  callChangePasswordDialog();
                },
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
                    addNewNameToMap: changeNameInList,
                    addChangedNameToList: changeNameInList,
                    resetPassword: resetPassword,
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
          },
          tooltip: 'Sekretariat hinzufügen',
          child: const Icon(Icons.add),
        ));
  }
}
