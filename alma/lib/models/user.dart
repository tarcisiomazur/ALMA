// -- user.dart --
import 'package:json_annotation/json_annotation.dart';

import 'farm.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String email;
  bool changePassword;
  String role;
  Farm farm;

  User(this.email,
      this.changePassword,
      this.role,
      this.farm,);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
