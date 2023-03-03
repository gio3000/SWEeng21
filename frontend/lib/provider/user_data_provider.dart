import 'package:flutter/material.dart';

class UserDataProvider with ChangeNotifier {
  void changePassword(String oldPwd, String newPwdOne, String newPwdTwo) {
    String newPwd = '';

    ///TODO check if old pwd is correct
    if (newPwdOne == newPwdTwo) {
      newPwd = newPwdOne;
    }

    ///TODO save newpwd in database
  }
}
