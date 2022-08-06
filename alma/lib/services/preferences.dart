import 'package:shared_preferences/shared_preferences.dart';

class Preferences{
  static late SharedPreferences _sharedPreferences;

  Preferences();

  static load() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences getInstance(){
    return _sharedPreferences;
  }
}