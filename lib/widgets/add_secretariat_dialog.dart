import 'package:flutter/material.dart';
import '../utils/constants.dart' as constants;

class CreateSecretary extends StatefulWidget {
  final Function addSecretariat;
  const CreateSecretary({super.key, required this.addSecretariat});

  @override
  State<CreateSecretary> createState() => _CreateSecretaryState();
}

class _CreateSecretaryState extends State<CreateSecretary> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(3 * constants.cPadding),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sekretariat hinzufügen',
                    style: TextStyle(fontSize: 25),
                  ),
                  const Spacer(),
                  const Text('Name eingeben'),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        label: Text('Name'),
                        hintText: 'Name des neuen Sekretariats eingeben'),
                  ),
                  const Spacer(),
                  const Text('Passwort eingeben'),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        label: Text('Passwort'),
                        hintText: 'Passwort des neuen Sekretariats eingeben'),
                  ),
                  const Spacer(),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.addSecretariat();
                    },
                    child: const Text('Speichern'),
                  ),
                ],
              ),
            )));
  }
}
