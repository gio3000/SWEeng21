import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';
import 'package:mysql1/mysql1.dart';
import '../utils/authenticated_request.dart';
import '../utils/db_constants.dart' as db;

class Admin extends User {
  List<String> _secretariesNames = [
    'Schmidt',
  ];
  bool isReady = false;
  List<dynamic> _secretaries = [];
  Admin({
    required int id,
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
        "role": 2,
        "salt": "salt",
        "hash_Count": 5,
        "initial_Password": password,
        "email": email
      }
    };
    _secretariesNames.add(name);
    AuthHttp.post("http://homenetwork-test.ddns.net:5160/api/secretary",
        body: jsonEncode(secreatry));
    await loadSecretaries();
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
        'update ${db.userTableName} set ${db.userPasswordKey}=Initial_Password where ${db.userIdKey}=?',
        [userID]);
    conn.close();
  }

  void changeSecretaryName(
      {required String oldName, required String newName}) async {
    int index = _secretariesNames.indexOf(oldName);
    _secretaries[index]["name"] = newName;
    int id = _secretaries[index]["secretaryID"];
    var body = jsonEncode(_secretaries[index]);
    AuthHttp.put("http://homenetwork-test.ddns.net:5160/api/secretary/$id",
        body: body);
  }

  void deleteSecretary({required String name}) async {
    int index = 0;
    for (int i = 0; i < _secretaries.length; i++) {
      if (_secretaries[i]["name"] == name) {
        index = i;
      }
    }
    debugPrint(index.toString());
    int secretaryID = _secretaries[index]["secretaryID"];
    debugPrint(secretaryID.toString());
    _secretariesNames.removeAt(index);
    _secretaries.removeAt(index);
    await AuthHttp.delete(
        "http://homenetwork-test.ddns.net:5160/api/secretary/$secretaryID");
    notifyListeners();
  }
}
