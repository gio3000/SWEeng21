import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/secretary_user.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/widgets/delete_list_tile.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as constants;

class SecretarySingleCourseStudentsScreen extends StatefulWidget {
  final String courseName;
  const SecretarySingleCourseStudentsScreen(
      {required this.courseName, super.key});

  @override
  State<SecretarySingleCourseStudentsScreen> createState() =>
      _SecretarySingleCourseStudentsScreenState();
}

class _SecretarySingleCourseStudentsScreenState
    extends State<SecretarySingleCourseStudentsScreen> {
  bool _isLoading = true;
  List<String> students = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => createStudent(),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : students.isEmpty
              ? const Center(
                  child: Text('Noch keine Studierenden in diesem Kurs!'),
                )
              : ListView(
                  children: students
                      .map((e) => DeleteListTile(
                            title: e,
                            onDelete: removeStudentFromCourse,
                          ))
                      .toList(),
                ),
    );
  }

  void createStudent() {
    final _formKey = GlobalKey<FormState>();
    String? matrikelNr;
    String? firstName;
    String? lastName;
    String? email;
    String? location;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '1234567',
                  label: Text('Matrikelnummer'),
                ),
                validator: validateMatrikelNr,
                onSaved: (newValue) => matrikelNr = newValue,
                maxLength: constants.cMaxInputLength,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Müller',
                  label: Text('Nachname'),
                ),
                validator: validateName,
                maxLength: constants.cMaxInputLength,
                onSaved: (newValue) => lastName = newValue,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Max', label: Text('Vorname')),
                maxLength: constants.cMaxInputLength,
                onSaved: (newValue) => firstName = newValue,
                validator: validateName,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'mueller.max-it21@it.dhbw-ravensburg.de',
                  label: Text('Email'),
                ),
                validator: validateEmail,
                maxLength: constants.cMaxInputLength,
                onSaved: (newValue) => email = newValue,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Ravensburg', label: Text('Ort')),
                maxLength: constants.cMaxInputLength,
                validator: validateName,
                onSaved: (newValue) => location = newValue,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      (Provider.of<User>(context, listen: false) as Secretary)
                          .createStudent(
                        firstName: firstName!,
                        lastName: lastName!,
                        email: email!,
                        location: location!,
                        matrikelNr: matrikelNr!,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Erstellen')),
            ],
          ),
        ),
      ),
    );
  }

  String? validateMatrikelNr(String? value) {
    if (value == null) return 'Bitte geben Sie eine MatrikelNummer ein!';
    if (value.length < 5) return 'Zu wenige Zeichen!';
    if (int.tryParse(value) == null) {
      return 'Bitte geben Sie eine valide Nummer an';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null) return 'Bitte geben Sie einen Namen ein';
    if (value.length < 2) return 'Bitte geben Sie mehr Zeichen ein!';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null) return 'Bitte geben Sie eine Email ein!';
    if (value.length < 5) return 'Bitte geben Sie mehr Zeichen ein!';
    if (!value.contains('@')) {
      return 'Bitte geben Sie eine valide Email-Adresse ein!';
    }
    return null;
  }

  void removeStudentFromCourse(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$name aus ${widget.courseName} entfernen'),
        content: Text(
          'Möchten Sie wirklich $name auf dem Kurs ${widget.courseName} entfernen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
              onPressed: () {
                (Provider.of<User>(context, listen: false) as Secretary)
                    .removeStudentFromCourse(
                        studentName: name, courseName: widget.courseName);
                Navigator.of(context).pop();
              },
              child: const Text('OK')),
        ],
      ),
    );
  }

  void loadData() async {
    (Provider.of<User>(context, listen: false) as Secretary)
        .getStudentsFor(widget.courseName)
        .then(
          (value) => setState(
            () {
              _isLoading = false;
              students = value;
            },
          ),
        );
  }
}
