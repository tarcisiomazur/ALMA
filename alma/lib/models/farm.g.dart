// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Farm _$FarmFromJson(Map<String, dynamic> json) => Farm(
      json['id'] as int,
      json['deviceId'] as String,
      json['propertyName'] as String,
    );

Map<String, dynamic> _$FarmToJson(Farm instance) => <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'propertyName': instance.propertyName,
    };
