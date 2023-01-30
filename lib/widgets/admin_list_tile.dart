import 'package:flutter/material.dart';

class AdminListTile extends StatefulWidget {
  final int index;
  final Function callAlert;
  const AdminListTile({
    super.key,
    required this.index,
    required this.callAlert,
  });

  @override
  State<AdminListTile> createState() => _AdminListTileState();
}

class _AdminListTileState extends State<AdminListTile> {
  final TextEditingController _controller = TextEditingController();

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        initiallyExpanded: isExpanded,
        title: Text('Sekretariat ${widget.index}'),
        children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Sekretariat ${widget.index}',
                    label: const Text('Name'),
                  ),
                )),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {}, child: Text('Passwort zurücksetzen')),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      widget.callAlert(
                          'Sekretariat ${widget.index}', widget.index);
                    },
                    child: Text('Löschen'))
              ],
            )
          ])
        ]);
  }
}
