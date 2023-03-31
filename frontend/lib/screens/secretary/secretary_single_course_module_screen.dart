import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/secretary_user.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/widgets/secretary_module_list_tile.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart' as constants;

class SecretarySingleCourseModuleScreen extends StatefulWidget {
  const SecretarySingleCourseModuleScreen({super.key});

  @override
  State<SecretarySingleCourseModuleScreen> createState() =>
      _SecretarySingleCourseModuleScreenState();
}

class _SecretarySingleCourseModuleScreenState
    extends State<SecretarySingleCourseModuleScreen> {
  bool _isLoading = true;
  List<GradeSubjectMapper> modules = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddingDialog();
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              children: modules
                  .map((e) => SecretaryModuleListTile(
                      moduleName: e.subjectName, creditPoints: e.creditPoints))
                  .toList(),
            ),
    );
  }

  void loadData() async {
    (Provider.of<User>(context, listen: false) as Secretary)
        .getAllModules()
        .then(
          (value) => setState(
            () {
              _isLoading = false;
              modules = value;
            },
          ),
        );
  }

  void showAddingDialog() {
    final _formKey = GlobalKey<FormState>();
    String moduleName = '';
    int ects = 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          margin: const EdgeInsets.all(constants.cPadding),
          width: MediaQuery.of(context).size.width / 2,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onSaved: (newValue) {
                    setState(() {
                      moduleName = newValue!;
                    });
                  },
                  validator: _validateTextInput,
                  maxLength: 60,
                  decoration: const InputDecoration(
                      label: Text('Name'), hintText: 'z.B.: Mathematik I'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: _validateTextInput,
                  maxLength: 60,
                  decoration: const InputDecoration(
                      label: Text('Vorlesung 1'), hintText: 'z.B.: Statistik'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: _validateTextInput,
                  maxLength: 60,
                  decoration: const InputDecoration(
                    label: Text('Vorlesung 2'),
                    hintText: 'z.B.: Angewandte Mathematik',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('ECTS'),
                    hintText: 'z.B.: 7',
                  ),
                  validator: (value) {
                    int? parsedVal = int.tryParse(value ?? '');
                    if (parsedVal == null) {
                      return 'Du musst eine Zahl angeben';
                    }
                    if (parsedVal > 25 && parsedVal < 1) {
                      return 'Du musst eine Zahl kleiner 25 und größer 1 angeben';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      ects = int.parse(newValue!);
                    });
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();
                      (Provider.of<User>(context, listen: false) as Secretary)
                          .addModule(moduleName: moduleName, cts: ects);
                      (Provider.of<User>(context, listen: false) as Secretary)
                          .getAllModules()
                          .then((value) => setState(() => modules = value));

                      Navigator.of(context).pop();
                    },
                    child: const Text('Abschicken'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateTextInput(String? value) {
    if (value == null) return 'Du musst ein Wert eingeben!';
    if (value.length < 4) {
      return 'Du musst mindestens 4 Zeichen eingeben!';
    }
  }
}
