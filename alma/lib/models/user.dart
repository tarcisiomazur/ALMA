// -- user.dart --
import 'package:json_annotation/json_annotation.dart';

import 'farm.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String email;
  String salt;
  String password;
  bool changePassword;
  String role;
  Farm farm;

  User(this.id,
      this.email,
      this.salt,
      this.password,
      this.changePassword,
      this.role,
      this.farm,);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
