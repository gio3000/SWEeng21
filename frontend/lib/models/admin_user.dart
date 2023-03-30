import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/secretary_user.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';
import '../utils/authenticated_request.dart';

class Admin extends User {
  List<String> _secretariesNames = [
    'Schmidt',
  ];
  bool isReady = false;
  List<dynamic> _secretaries = [];
  Admin({
    required String id,
    required String firstName,
    required String lastName,
    required UserRole role,
    required String email,
  }) : super(
            id: id,
            firstName: firstName,
            lastName: lastName,
            role: role,
            email: email);

  Future<List<String>> getSecretaries() async {
    return loadSecretaries();
  }

  Future<List<String>> loadSecretaries() async {
    var response = await AuthHttp.get(
        "http://homenetwork-test.ddns.net:5160/api/secretary");
    var secrets = json.decode(response.body);
    List<UserRole> roles = UserRole.values;
    _secretariesNames.clear();
    for (int i = 0; i < secrets.length; i++) {
      int roleNumber = secrets[i]["user"]["role"];
      if (secrets[i]["name"] != null) {
        _secretaries.add(secrets[i]);
        _secretariesNames.add(secrets[i]["name"]);
      }
    }
    return _secretariesNames;
  }

  void addSecretary(
      {required String name,
      required String password,
      required String email}) async {
    var secreatry = {
      "name": name,
      "user": {
        "password": password,
        "first_Name": "first_Name",
        "role": 2,
        "salt": "salt",
        "initial_Salt": "initial_Salt",
        "hash_Count": 5,
        "last_Name": "last_Name",
        "initial_Password": "initial_Password",
        "email": email
      }
    };
    _secretariesNames.add(name);
    var response = await AuthHttp.post(
        "http://homenetwork-test.ddns.net:5160/api/secretary",
        body: jsonEncode(secreatry));
    notifyListeners();
  }

  void resetSecretaryPassword({required String name}) async {
    //TODO
  }

  void changeSecretaryName(
      {required String oldName, required String newName}) async {
    int index = _secretariesNames.indexOf(oldName);
    debugPrint(index.toString());
  }

  void deleteSecretary({required String name}) async {
    int index = _secretariesNames.indexOf(name);
    _secretariesNames.removeAt(index);
    int id = int.parse(_secretaries[index].id);
    _secretaries.removeAt(index);
    debugPrint(_secretariesNames.toString());
    debugPrint(_secretaries.toString());
    var response = await AuthHttp.delete(
        "http://homenetwork-test.ddns.net:5160/api/secretary/?id=$id");
    debugPrint(response.statusCode.toString());
    notifyListeners();
  }
}
