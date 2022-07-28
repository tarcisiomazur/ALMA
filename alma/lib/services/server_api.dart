import 'dart:convert';
import 'dart:io';

import 'package:alma/assets/api_constants.dart';
import 'package:alma/services/preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ServerApi {
  static final ServerApi _instance = ServerApi();
  String? _token;
  String urlBase = dotenv.get("API_URL");
  http.Client client = http.Client();
  Function? onLogout;

  Future logout() async{
    Preferences.getInstance().remove("token");
    if(onLogout != null){
      onLogout!();
    }
  }

  Future<String?> authUser(String email, String password) async {
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

  Future<String?> registerUser(String email, String password, String deviceId) async {
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


  Future<String?> recoverPassword(String email) {
    return client.post(
        getUrl(recover),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Email": email,
        })
    ).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data["success"] == true) {
          return null;
        } else {
          return getMessageError(data);
        }
      } else {
        return response.toString();
      }
    });
  }

  Uri getUrl(String subPath) {
    return Uri.parse("$urlBase/$subPath");
  }

  String getMessageError(Map<String, dynamic> data) {
    var x = data['messageList'] as List;
    var list = (x).map((item) => item as String).toList();
    return list.join("\n");
  }

  void setToken(String newToken) {
    _token = newToken;
    Preferences.getInstance().setString("token", newToken);
  }

  Future<bool> getLoggedUser() async {
    _token = Preferences.getInstance().getString("token");
    if (_token != null) {
      return true;
    }
    return false;
  }
  ServerApi({
    this.onLogout,
  });

  static ServerApi getInstance() {
    return _instance;
  }

}
