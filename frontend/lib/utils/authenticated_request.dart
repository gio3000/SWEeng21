import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart' as constants;

/// Zur Info:
/// - jede request gibt den vollständigen user zurück

class AuthHttp {
  static Future<http.Response> get(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(constants.authTokenSharedPrefKey) ?? '';
    return await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $authToken',
      "Content-Type": "application/json",
    });
  }

  static Future<http.Response> post(String url, {String? body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(constants.authTokenSharedPrefKey) ?? '';
    return await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json",
      },
      body: body,
    );
  }

  static Future<http.Response> delete(String url, {String? body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(constants.authTokenSharedPrefKey) ?? '';
    return await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json",
      },
      body: body,
    );
  }

  static Future<http.Response> put(String url, {String? body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString(constants.authTokenSharedPrefKey) ?? '';
    return await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json",
      },
      body: body,
    );
  }
}
