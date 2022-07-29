// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Production _$ProductionFromJson(Map<String, dynamic> json) => Production(
      json['id'] as int,
      DateTime.parse(json['time'] as String),
      json['cowId'] as int,
    );

Map<String, dynamic> _$ProductionToJson(Production instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time.toIso8601String(),
      'cowId': instance.cowId,
    };
