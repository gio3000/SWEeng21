import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/errors/authorization_exception.dart';
import 'package:http/http.dart' as http;

class AuthorizationProvider with ChangeNotifier {
  String? _authorizationToken;

  AuthorizationProvider();

  ///tries to fetch the `authenticationToken` from the Webserver
  ///it sends `userName` and `password` to the Webserver. If these credentials
  ///are approved the server should send a token back otherwise null is stored in
  ///`authenticationToken`
  Future<void> tryToGetTokenWith(String userName, String password) async {
    final response = await http.get(Uri.parse('TODO')); //TODO add correct url
    if (response.statusCode >= 400) {
      throw AuthorizationException();
    } else {
      final parsedResponse = json.decode(response.body);
      _authorizationToken = parsedResponse['token'];
    }
  }

  //TODO maybe move this to another file
  Future<Map<String, dynamic>> authorizedRequest(Uri url) async {
    if (_authorizationToken == null) throw AuthorizationException();
    final response = await http
        .post(url, headers: {'Authorization': 'Bearer $_authorizationToken'});
    return json.decode(response.body);
  }
}
