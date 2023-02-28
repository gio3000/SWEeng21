import 'package:http/http.dart';

class AuthorizationException implements Exception {
  AuthorizationException();

  @override
  String toString() {
    return 'Authentifizierung hat nicht funktioniert!.\nBitte versuchen Sie es noch einmal!';
  }
}
