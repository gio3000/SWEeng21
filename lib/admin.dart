import 'package:flutter/material.dart';

class AdminTechnisch extends StatefulWidget {
  const AdminTechnisch({super.key, required this.title});
  final String title;
  @override
  State<AdminTechnisch> createState() => _Admintechnisch();
}

class _Admintechnisch extends State<AdminTechnisch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              icon: const Icon(Icons.edit)),
                          const SizedBox(
                            width: 25,
                          ),
                          IconButton(
                              onPressed: () {},
                              tooltip: 'Sekretariat entfernen',
                              icon: const Icon(Icons.delete)),
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
