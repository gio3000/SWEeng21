import 'package:flutter/material.dart';
import 'package:frontend/models/grade.dart';

class UserDataProvider with ChangeNotifier {
  final _courses = ['TIT21', 'TIK21', 'TEM22', 'TEK19', 'TIS18'];
  final _lecturers = ['Sommer', 'Maus', 'Kegreiß', 'Schneider', 'Vollkorn Bio'];
  void changePassword(String oldPwd, String newPwdOne, String newPwdTwo) {
    String newPwd = '';

    ///TODO check if old pwd is correct
    if (newPwdOne == newPwdTwo) {
      newPwd = newPwdOne;
    }

    ///TODO save newpwd in database
  }

  Future<List<GradeSubjectMapper>> getGradesFrom(String token) async {
    await Future.delayed(const Duration(seconds: 1));
    // return [];
    //TODO
    return <GradeSubjectMapper>[
      GradeSubjectMapper(
        subjectName: "Systemnahe Programmierung",
        grade: 1.6,
        examDate: DateTime.now(),
      ),
      GradeSubjectMapper(
          subjectName: "Theoretische Informatik I",
          grade: 4.8,
          examDate: DateTime.now()),
      GradeSubjectMapper(
        subjectName: "WebEngineering",
        grade: 3.2,
        examDate: DateTime.now(),
      ),
      GradeSubjectMapper(
        subjectName: "Analysis",
        grade: 5.0,
        examDate: DateTime.now(),
      ),
      GradeSubjectMapper(
        subjectName: "Datenbanken",
        grade: 1.8,
        examDate: DateTime.now(),
      ),
    ];
  }

  Future<List<String>> getCourses() async {
    await Future.delayed(const Duration(seconds: 1));
    return _courses;
  }

  void addCourse(String title) {
    _courses.add(title);
    notifyListeners();
  }

  void deleteCourse(String title) {
    _courses.removeWhere((element) => title == element);
    notifyListeners();
  }

  Future<List<String>> getLecturer() async {
    await Future.delayed(const Duration(seconds: 1));
    return _lecturers;
  }

  void addLecturer(String name) {
    _lecturers.add(name);
    notifyListeners();
  }

  void deleteLecturer(String name) {
    _lecturers.removeWhere((element) => element == name);
    notifyListeners();
  }
}
