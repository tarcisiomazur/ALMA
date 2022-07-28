// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['email'] as String,
      json['salt'] as String,
      json['password'] as String,
      json['changePassword'] as bool,
      json['role'] as String,
      Farm.fromJson(json['farm'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'salt': instance.salt,
      'password': instance.password,
      'changePassword': instance.changePassword,
      'role': instance.role,
      'farm': instance.farm,
    };
