import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/errors/authorization_exception.dart';
import 'package:frontend/models/admin_user.dart';
import 'package:frontend/models/secretary_user.dart';
import 'package:frontend/models/student_user.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/utils/authenticated_request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart' as constants;

class AuthorizationProvider with ChangeNotifier {
  String? authorizationToken;
  User? authorizedUser;

  ///tries to fetch the `authenticationToken` from the Webserver
  ///it sends `userName` and `password` to the Webserver. If these credentials
  ///are approved the server should send a token back otherwise null is stored in
  ///`authenticationToken`
  ///TODO delete userRole in params
  Future<void> authorize(String email, String password, UserRole role) async {
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
      switch (role) {
        case UserRole.student:
          authorizedUser = Student(
            email: 'test@test.com',
            firstName: 'test',
            lastName: 'test',
            id: 'test',
            role: role,
          );
          break;
        case UserRole.secretary:
          authorizedUser = Secretary(
            email: 'test@test.com',
            firstName: 'test',
            lastName: 'test',
            id: 'test',
            role: role,
          );
          break;
        case UserRole.admin:
          authorizedUser = Admin(
            email: 'test@test.com',
            firstName: 'test',
            lastName: 'test',
            id: 'test',
            role: role,
          );
          break;
        default:
          throw AuthorizationException();
      }
      notifyListeners();
    }
  }

  void logout() {
    authorizationToken = null;
  }
}
