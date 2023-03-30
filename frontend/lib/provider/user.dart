import 'package:flutter/material.dart';
import 'package:frontend/models/user_role.dart';
import '../utils/constants.dart' as constants;

class User with ChangeNotifier {
  final String id;
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

  static User fromMap(Map<String, Object?> map) {
    return User(
        id: map[constants.userIdKey] as String? ?? '',
        firstName: map[constants.userFirstNameKey] as String? ?? '',
        lastName: map[constants.userLastNameKey] as String? ?? '',
        role: map[constants.userRoleKey] as UserRole? ?? UserRole.invalid,
        email: map[constants.userEmailKey] as String? ?? '');
  }
}
