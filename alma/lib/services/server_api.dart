import 'dart:convert';
import 'dart:io';

import 'package:alma/assets/api_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServerApi {
  static String? token;
  static String urlBase = dotenv.get("API_URL");
  static http.Client client = http.Client();
  static SharedPreferences? sharedPreferences;

  static Future<String?> authUser(String email, String password) async {
    return client.post(
      getUrl(login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"Email": email, "Password": password}),
    ).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data["success"] == true && data["token"] != null) {
          setToken(data["token"]);
          return null;
        } else {
          return getMessageError(data);
        }
      } else {
        return response.toString();
      }
    });
  }

  static Future<String?> registerUser(String email, String password, String deviceId) async {
    return client.post(
        getUrl(register),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Email": email,
          "Password": password,
          "DeviceId": deviceId,
        })
    ).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data["success"] == true && data["token"] != null) {
          setToken(data["token"]);
          return null;
        } else {
          return getMessageError(data);
        }
      } else {
        return response.toString();
      }
    });
  }

  static Uri getUrl(String subPath) {
    return Uri.parse("$urlBase/$subPath");
  }

  static String getMessageError(Map<String, dynamic> data) {
    var x = data['messageList'] as List;
    var list = (x).map((item) => item as String).toList();
    return list.join("\n");
  }

  static void setToken(String newToken) {
    token = newToken;
    sharedPreferences?.setString("token", newToken);
  }

  static Future<bool> getLoggedUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences?.getString("token");
    if (token != null) {
      return true;
    }
    return false;
  }
}
