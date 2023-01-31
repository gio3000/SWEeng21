import 'package:flutter/material.dart';

class AdminListTile extends StatefulWidget {
  final int index;
  final Function callAlert;
  final String name;
  final Function addNewNameToMap;
  final Function addChangedNameToList;
  const AdminListTile(
      {super.key,
      required this.index,
      required this.callAlert,
      required this.name,
      required this.addNewNameToMap,
      required this.addChangedNameToList});

  @override
  State<AdminListTile> createState() => _AdminListTileState();
}

class _AdminListTileState extends State<AdminListTile> {
  final TextEditingController _nameController = TextEditingController();

  bool isExpanded = false;

  ///determines whether ExpansionTile is expanded
  bool saveButtonEnabled = false;

  ///determines whether changes at secretariats can be saved or not

  late String secretaryName = widget.name;

  ///this function changes Secretary name
  void changeTitle() {
    setState(() {
      secretaryName = _nameController.text;
    });
  }

  ///calls the addNewNameToMap-function from admin_screen
  void addNameToMap(int index) {
    widget.addNewNameToMap(index - 1, _nameController.text);
  }

  ///handles the state of the bool value of saveButtonEnabled
  void checkSaveButtonEnabled() {
    if (_nameController.text != "") {
      saveButtonEnabled = true;
    } else {
      saveButtonEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        initiallyExpanded: isExpanded,
        title: Text(secretaryName),
        children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: TextField(
                  maxLength: 60,

                  ///TODO Namenslänge definieren
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: secretaryName,
                    label: const Text('Name'),
                  ),
                  onChanged: (value) => setState(() {
                    checkSaveButtonEnabled();
                  }),
                )),
                const Spacer(),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {},
                    child: const Text('Passwort zurücksetzen')),
                const Spacer(),
                ElevatedButton(
                    onPressed: saveButtonEnabled
                        ? () {
                            changeTitle();
                            addNameToMap(widget.index);
                            widget.addChangedNameToList(
                                widget.index, _nameController.text);
                          }
                        : null,
                    child: const Text('Speichern')),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      widget.callAlert(
                          'Sekretariat ${widget.index}', widget.index);
                    },
                    child: const Text('Löschen'))
              ],
            )
          ])
        ]);
  }
}
