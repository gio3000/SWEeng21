import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/errors/authorization_exception.dart';
import 'package:frontend/models/admin_user.dart';
import 'package:frontend/models/secretary_user.dart';
import 'package:frontend/models/student_user.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/db_constants.dart' as db;
import '../utils/constants.dart' as constants;

class AuthorizationProvider with ChangeNotifier {
  String? authorizationToken;
  User? authorizedUser;

  ///tries to fetch the `authenticationToken` from the Webserver
  ///it sends `userName` and `password` to the Webserver. If these credentials
  ///are approved the server should send a token back otherwise null is stored in
  ///`authenticationToken`
  Future<UserRole> authorize(String email, String password) async {
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
      final List<dynamic> parsedResponse = json.decode(response.body);
      if (parsedResponse.isEmpty) throw AuthorizationException();

      //save token in cookie
      authorizationToken = parsedResponse[0][db.tokenKey] as String?;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          constants.authTokenSharedPrefKey, authorizationToken ?? '');

      //fetch user data
      final userData =
          parsedResponse[0][db.userTableName] as Map<String, Object?>?;
      if (userData == null) throw AuthorizationException();
      UserRole role = UserRole.values[userData[db.userRoleKey] as int];

      //set authorizedUser
      switch (role) {
        case UserRole.student:
          authorizedUser = Student(
            email: userData[db.userEmailKey] as String? ?? '',
            firstName: userData[db.userFirstNameKey] as String? ?? '',
            lastName: userData[db.userLastNameKey] as String? ?? '',
            id: userData[db.userIdKey] as int? ?? 0,
            role: role,
          );
          break;
        case UserRole.secretary:
          authorizedUser = Secretary(
            email: userData[db.userEmailKey] as String? ?? '',
            firstName: userData[db.userFirstNameKey] as String? ?? '',
            lastName: userData[db.userLastNameKey] as String? ?? '',
            id: userData[db.userIdKey] as int? ?? 0,
            role: role,
          );
          break;
        case UserRole.admin:
          authorizedUser = Admin(
            email: userData[db.userEmailKey] as String? ?? '',
            firstName: userData[db.userFirstNameKey] as String? ?? '',
            lastName: userData[db.userLastNameKey] as String? ?? '',
            id: userData[db.userIdKey] as int? ?? 0,
            role: role,
          );
          break;
        default:
          throw AuthorizationException();
      }
      notifyListeners();
      return role;
    }
  }

  void logout() {
    authorizationToken = null;
    authorizedUser?.role = UserRole.invalid;
    notifyListeners();
  }
}
