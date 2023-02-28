import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/errors/authorization_exception.dart';
import 'package:frontend/models/grade.dart';
import 'package:frontend/utils/authenticated_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart' as constants;

class AuthorizationProvider with ChangeNotifier {
  String? authorizationToken;
  final _courses = ['TIT21', 'TIK21', 'TEM22', 'TEK19', 'TIS18'];
  final _lecturers = ['Sommer', 'Maus', 'Kegreiß', 'Schneider', 'Vollkorn Bio'];

  ///tries to fetch the `authenticationToken` from the Webserver
  ///it sends `userName` and `password` to the Webserver. If these credentials
  ///are approved the server should send a token back otherwise null is stored in
  ///`authenticationToken`
  Future<void> authorize(String email, String password) async {
    Map<String, String> authorizationData = {
      "email": email,
      "password": password,
    };
    final response = await http.post(
        Uri.parse(
          'http://homenetwork-test.ddns.net:5160/api/token',
        ),
        body: json.encode(authorizationData),
        headers: {
          "Content-Type": "application/json",
        });
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode >= 400) {
      throw AuthorizationException();
    } else {
      authorizationToken = response.body;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          constants.authTokenSharedPrefKey, authorizationToken ?? '');

      await AuthHttp.delete(
        'http://homenetwork-test.ddns.net:5160/api/user/15',
      );
      notifyListeners();
    }
  }

  //TODO maybe move this to another file
  Future<Map<String, dynamic>> authorizedRequest(Uri url) async {
    if (authorizationToken == null) throw AuthorizationException();
    final response = await http
        .post(url, headers: {'Authorization': 'Bearer $authorizationToken'});
    return json.decode(response.body);
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

  void logout() {
    authorizationToken = null;
  }
}
