import 'package:shared_preferences/shared_preferences.dart';

class Preferences{
  static late SharedPreferences sharedPreferences;

  Preferences();

  static load() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences getInstance(){
    return sharedPreferences;
  }
}