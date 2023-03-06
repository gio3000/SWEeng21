import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/secretary_user.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/widgets/secretary_module_list_tile.dart';
import 'package:provider/provider.dart';

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
          showDialog(context: context, builder: (context) => AlertDialog());
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
}
