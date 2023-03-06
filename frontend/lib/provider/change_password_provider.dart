import 'package:flutter/material.dart';

class ChangePwdProvider with ChangeNotifier {
  ///String to save the new Password
  late String newPassword;

  ///sets new Password so it can be transfered to Database
  void setNewPassword(String oldPwd, String newPwdOne, String newPwdTwo) {
    ///TODO check if old pwd is correct
    if (newPwdOne == newPwdTwo && newPwdOne != oldPwd) {
      newPassword = newPwdOne;
      debugPrint(newPwdOne);
    }
  }
}
