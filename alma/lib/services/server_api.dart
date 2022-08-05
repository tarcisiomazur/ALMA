import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alma/assets/constants/api_constants.dart';
import 'package:alma/models/cow.dart';
import 'package:alma/models/user.dart';
import 'package:alma/services/api_response.dart';
import 'package:alma/services/preferences.dart';
import 'package:alma/services/web_socket.dart';
import 'package:http/http.dart' as http;


class ServerApi {
  static final ServerApi _instance = ServerApi();
  String? token;
  String urlBase = "http://192.168.1.5:20240";
  http.Client client = http.Client();
  Function? onLogout;
  late Map<String, String> authHeader;
  String? connId;


  Future logout() async{
    Preferences.getInstance().remove("token");
    if(onLogout != null){
      onLogout!();
    }
  }

  Future<String?> authUser(String email, String password) async {
    return await client.post(
      getUrl(apiAuthLogin),
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
        getUrl(apiAuthRegister),
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
        getUrl(apiAuthRecover),
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
    token = newToken;
    buildAuthHeader();
    ApiWebSocket.getInstance().Init();
    Preferences.getInstance().setString("token", newToken);
  }

  void buildAuthHeader(){
    authHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> getLoggedUser() async {
    token = Preferences.getInstance().getString("token");
    if (token != null) {
      setToken(token!);
      return true;
    }
    return false;
  }

  ServerApi({this.onLogout,}){
    ApiWebSocket.getInstance().connected.listen((connId){
      this.connId = connId;
      buildAuthHeader();
    });
  }

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
      getUrl(apiUserData),
      headers: authHeader,
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

  Future<APIResponse<List<Cow>>> getCows() {
    return client.get(
      getUrl(apiGetCows),
      headers: authHeader,
    ).then(checkResponse((response) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["success"] == true) {
        if(data["payload"] is! List){
          return APIResponse(error: true, errorMessage: "A lista de Vacas está vazia");
        }
        List<Cow> cows = [];
        data["payload"].forEach((e) => cows.add(Cow.fromJson(e)));
        return APIResponse(data: cows);
      } else {
        return APIResponse(
            error: true, errorMessage: getMessageError(data));
      }
    }));
  }

  Future<APIResponse> changePassword(String? email, String? oldPassword, String newPassword) {
    return client.post(
        getUrl(apiAuthChange),
        headers: authHeader,
        body: jsonEncode(<String, String>{
          "Email": email??"",
          "NewPassword": newPassword,
          "OldPassword": oldPassword ?? "",
        })
    ).then(checkResponse((response) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data["success"] == true) {
        return APIResponse();
      }else{
        return APIResponse(
            error: true, errorMessage: getMessageError(data));
      }
    }));
  }

}
