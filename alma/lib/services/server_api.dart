import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alma/assets/api_constants.dart';
import 'package:alma/models/user.dart';
import 'package:alma/services/preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'api_response.dart';

class ServerApi {
  static final ServerApi _instance = ServerApi();
  String? _token;
  String urlBase = dotenv.get("API_URL");
  http.Client client = http.Client();
  Function? onLogout;
  late Map<String, String> defaultHeader;


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
    buildDefaultHeader();
    Preferences.getInstance().setString("token", newToken);
  }

  void buildDefaultHeader(){
    defaultHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token'
    };
  }

  Future<bool> getLoggedUser() async {
    _token = Preferences.getInstance().getString("token");
    if (_token != null) {
      buildDefaultHeader();
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

  FutureOr<APIResponse<T>> Function(http.Response) checkResponse<T>(
      FutureOr<APIResponse<T>> Function(http.Response response) onValue) {
    return (response) {
      switch(response.statusCode){
        case HttpStatus.ok:
          return onValue(response);
        case HttpStatus.unauthorized:
          logout();
          return APIResponse(error: true,errorMessage: "Usuário não autorizado", errorCode: 401);
        default:
          return APIResponse(error: true, errorMessage: "Erro ${response.statusCode}");
      }
    };
  }

  Future<APIResponse<User>> getUserData() {
    return client.get(
      getUrl(userData),
      headers: defaultHeader,
    ).then(checkResponse((response) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["success"] == true) {
        return APIResponse(data: User.fromJson(data["payload"]));
      } else {
        return APIResponse(
            error: true, errorMessage: getMessageError(data));
      }
    }));
  }

}
