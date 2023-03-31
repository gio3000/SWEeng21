import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_role.dart';
import '../utils/authenticated_request.dart';
import '../utils/constants.dart' as constants;
import '../utils/db_constants.dart' as db;

class User with ChangeNotifier {
  final int id;
  String firstName;
  String lastName;
  String email;
  UserRole role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
  });

  void changePassword(String oldPwd, String newPwdOne, String newPwdTwo) async {
    if (oldPwd == newPwdOne) {
      throw Exception('Old and new password are the same');
    }
    if (newPwdOne != newPwdTwo) {
      throw Exception('New passwords do not match');
    }
    if (newPwdOne == newPwdTwo && oldPwd != newPwdOne) {
      var response = await AuthHttp.get(
          "http://homenetwork-test.ddns.net:5160/api/user/$id");
      if (response.statusCode == 200) {
        var user = jsonDecode(response.body);
        if (user["password"] != oldPwd) {
          throw Exception('Old password is incorrect');
        } else {
          user["password"] = newPwdOne;
          await AuthHttp.put(
              "http://homenetwork-test.ddns.net:5160/api/user/$id",
              body: jsonEncode(user));
        }
      }
    }
  }
}
