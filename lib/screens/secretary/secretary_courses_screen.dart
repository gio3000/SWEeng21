import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/provider/authorization_provider.dart';
import 'package:frontend/widgets/delete_list_tile.dart';
import 'package:provider/provider.dart';

// import '../../utils/constants.dart' as constants;

class SecretaryCoursesScreen extends StatefulWidget {
  const SecretaryCoursesScreen({super.key});

  @override
  State<SecretaryCoursesScreen> createState() => _SecretaryCoursesScreenState();
}

class _SecretaryCoursesScreenState extends State<SecretaryCoursesScreen> {
  bool _isLoading = true;
  List<String> courses = [];

  @override
  void initState() {
    Provider.of<AuthorizationProvider>(context, listen: false)
        .getCourses()
        .catchError((details) => <String>[])
        .then((value) => setState(() {
              _isLoading = false;
              courses = value;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _ = Provider.of<AuthorizationProvider>(context);
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer(
              builder: (context, AuthorizationProvider value, child) =>
                  ListView(
                children: courses
                    .map((e) => DeleteListTile(
                          title: e,
                          onDelete: onDeleteCourse,
                        ))
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCourseDialog(context),
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}

void onDeleteCourse(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Kurs $title löschen'),
      content: Text(
        '''
Bist du dir sicher, dass du den Kurs $title 
unwiderruflich löschen möchtest?
        ''',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        TextButton(
            onPressed: () {
              Provider.of<AuthorizationProvider>(context, listen: false)
                  .deleteCourse(title);
              Navigator.of(context).pop();
            },
            child: const Text('OK'))
      ],
    ),
  );
}

///draws a dialog on the screen where new courses can be added
void _showAddCourseDialog(BuildContext context) {
  GlobalKey<FormState> formKey = GlobalKey();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Form(
        key: formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            maxLength: 7,
            validator: validateAddCourseInput,
            onSaved: (text) {
              Provider.of<AuthorizationProvider>(context, listen: false)
                  .addCourse(text!);
            },
            decoration: const InputDecoration(
                hintText: 'TIT23', label: Text('Kurskürzel')),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Hinzufügen'),
          ),
        ]),
      ),
    ),
  );
}

String? validateAddCourseInput(String? text) {
  text ??= '';
  if (text.length < 4) return "Zu wenige Zeichen!";
  return null;
}
