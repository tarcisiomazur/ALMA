// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cow _$CowFromJson(Map<String, dynamic> json) => Cow(
      id: json['id'] as int? ?? 0,
      tag: json['tag'] as String? ?? "",
      weight: json['weight'] as int? ?? 0,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      deathDate: json['deathDate'] == null
          ? null
          : DateTime.parse(json['deathDate'] as String),
      farm: json['farm'] == null
          ? null
          : Farm.fromJson(json['farm'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CowToJson(Cow instance) => <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'weight': instance.weight,
      'birthDate': instance.birthDate?.toIso8601String(),
      'deathDate': instance.deathDate?.toIso8601String(),
      'farm': instance.farm,
    };
