// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['email'] as String,
      json['changePassword'] as bool,
      json['role'] as String,
      Farm.fromJson(json['farm'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'changePassword': instance.changePassword,
      'role': instance.role,
      'farm': instance.farm,
    };
