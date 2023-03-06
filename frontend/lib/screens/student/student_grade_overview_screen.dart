import 'package:flutter/material.dart';
import 'package:frontend/models/grade_subject_mapper.dart';
import 'package:frontend/models/student_user.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/widgets/grade_subject_list_tile.dart';
import 'package:provider/provider.dart';

class StudentOverViewScreen extends StatefulWidget {
  static const routeName = '/student/gradeoverview';
  const StudentOverViewScreen({super.key});

  @override
  State<StudentOverViewScreen> createState() => _StudentOverViewScreenState();
}

class _StudentOverViewScreenState extends State<StudentOverViewScreen> {
  bool _isLoading = true;
  List<GradeSubjectMapper> gradeSubjectMapperList = [];

  @override
  void initState() {
    (Provider.of<User>(context, listen: false) as Student)
        .getGrades()
        .then((value) => setState(() {
              gradeSubjectMapperList = value;
              _isLoading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notenübersicht')),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : gradeSubjectMapperList.isEmpty
              ? const Center(
                  child: Text('Du hast noch keine Noten eingetragen!'),
                )
              : ListView(
                  children: gradeSubjectMapperList
                      .map((mapper) => GradeSubjectListTile(mapper: mapper))
                      .toList()),
    );
  }
}
