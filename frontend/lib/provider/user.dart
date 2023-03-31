import 'package:flutter/material.dart';
import 'package:frontend/models/user_role.dart';
import '../utils/constants.dart' as constants;
import '../utils/db_constants.dart' as db;

class User with ChangeNotifier {
  int id;
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

  void changePassword(String oldPwd, String newPwdOne, String newPwdTwo) {
    String newPwd = '';

    ///TODO check if old pwd is correct
    if (newPwdOne == newPwdTwo) {
      newPwd = newPwdOne;
    }

    ///TODO save newpwd in database
  }
}
