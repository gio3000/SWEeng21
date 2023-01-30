import 'package:flutter/material.dart';

class AdminListTile extends StatefulWidget {
  final int index;
  final Function callAlert;
  final String name;
  final Function addNewNameToMap;
  const AdminListTile(
      {super.key,
      required this.index,
      required this.callAlert,
      required this.name,
      required this.addNewNameToMap});

  @override
  State<AdminListTile> createState() => _AdminListTileState();
}

class _AdminListTileState extends State<AdminListTile> {
  final TextEditingController _controller = TextEditingController();

  bool isExpanded = false;

  ///determines whether ExpansionTile is expanded
  bool saveButtonEnabled = false;

  ///determines whether changes at secretariats can be saved or not

  late String secretaryName = widget.name;

  ///this function changes Secretary name
  void changeTitle() {
    setState(() {
      secretaryName = _controller.text;
    });
  }

  ///calls the addNewNameToMap-function from admin_screen
  void addNameToMap(int index) {
    widget.addNewNameToMap(index - 1, _controller.text);
  }

  ///handles the state of the bool value of saveButtonEnabled
  void checkSaveButtonEnabled() {
    if (_controller.text != "") {
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
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: secretaryName,
                    label: const Text('Name'),
                  ),
                  onChanged: (value) => setState(() {
                    checkSaveButtonEnabled();
                  }),
                )),
                const Spacer(),
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                  onChanged: (value) => setState(() {
                    checkSaveButtonEnabled();
                  }),
                )),
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
