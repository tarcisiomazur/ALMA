// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Production _$ProductionFromJson(Map<String, dynamic> json) => Production(
      json['id'] as int,
      DateTime.parse(json['time'] as String),
      Cow.fromJson(json['cow'] as Map<String, dynamic>),
      json['cowId'] as int,
    );

Map<String, dynamic> _$ProductionToJson(Production instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time.toIso8601String(),
      'cow': instance.cow,
      'cowId': instance.cowId,
    };
