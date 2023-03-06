import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/secretary_user.dart';
import 'package:frontend/provider/authorization_provider.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/widgets/delete_list_tile.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart' as constants;

class SecretaryLecturerScreen extends StatefulWidget {
  const SecretaryLecturerScreen({super.key});

  @override
  State<SecretaryLecturerScreen> createState() =>
      _SecretaryLecturerScreenState();
}

class _SecretaryLecturerScreenState extends State<SecretaryLecturerScreen> {
  List<String> lecturers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    (context.read<User>() as Secretary).getLecturers().then((value) {
      setState(() {
        _isLoading = false;
        lecturers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _ = Provider.of<User>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddLecturerDialog(context),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: lecturers
                  .map((name) =>
                      DeleteListTile(title: name, onDelete: onDeleteLecturer))
                  .toList(),
            ),
    );
  }

  void onDeleteLecturer(BuildContext context, String name) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Dozent $name löschen'),
              content: Text(
                  'Möchten Sie wirklich den Dozenten $name\nunwiderruflich löschen?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                    onPressed: () {
                      (context.read<User>() as Secretary)
                          .removeLecturer(lecturerName: name);
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  void showAddLecturerDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      maxLength: constants.cMaxInputLength,
                      validator: (value) {
                        if ((value?.length ?? 0) < 3) {
                          return 'Zu wenige Buchstaben eingegeben';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        (context.read<User>() as Secretary)
                            .addLecturer(lecturerName: newValue!);
                      },
                      decoration: const InputDecoration(
                          hintText: 'Max Müller', label: Text('Dozentenname')),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Hinzufügen')),
                  ],
                ),
              ),
            ));
  }
}
