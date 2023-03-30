import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';
import 'package:mysql1/mysql1.dart';
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
        "initial_Password": password,
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
    int index = 0;
    for (int i = 0; i < _secretaries.length; i++) {
      if (_secretaries[i]["name"] == name) {
        index = i;
      }
    }
    int userID = _secretaries[index]["userID"];
    var settings = ConnectionSettings(
        host: '31.47.240.136',
        port: 3307,
        user: 'SWENGUser',
        password: 'WkvUqQ2@DpCn',
        db: 'SWENGDB');
    var conn = await MySqlConnection.connect(settings);
    await conn.query(
        'update User set Password=Initial_Password where userID=?', [userID]);
    conn.close();
  }

  void changeSecretaryName(
      {required String oldName, required String newName}) async {
    int index = _secretariesNames.indexOf(oldName);
    _secretaries[index]["name"] = newName;
    debugPrint(_secretaries[index].toString());
    debugPrint(index.toString());
  }

  void deleteSecretary({required String name}) async {
    int index = _secretariesNames.indexOf(name);
    _secretariesNames.removeAt(index);
    int id = _secretaries[index]["secretaryID"];
    _secretaries.removeAt(index);
    debugPrint(_secretaries.toString());
    var response = await AuthHttp.delete(
        "http://homenetwork-test.ddns.net:5160/api/secretary/$id");
    notifyListeners();
  }
}
