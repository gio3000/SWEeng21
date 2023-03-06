import 'package:frontend/models/user_role.dart';
import 'package:frontend/provider/user.dart';

class Admin extends User {
  final List<String> _secretaries = [
    'Schmidt',
  ];

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
    return _secretaries;
  }

  void addSecretary({required String name, required String password}) async {
    _secretaries.add(name);
    //TODO add password
  }

  void resetSecretaryPassword({required String name}) async {
    //TODO
  }

  void changeSecretaryName(
      {required String oldName, required String newName}) async {
    //TODO add authhttp
    int index = _secretaries.indexWhere((element) => element == newName);
    _secretaries[index] = newName;
    notifyListeners();
  }

  void deleteSecretary({required String name}) async {
    //TODO add authhttp
    _secretaries.removeWhere((element) => element == name);
  }
}
