// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cow _$CowFromJson(Map<String, dynamic> json) => Cow(
      id: json['id'] as int? ?? 0,
      tag: json['tag'] as String? ?? '',
      identification: json['identification'] as String? ?? '',
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      bcs: json['bcs'] as int? ?? 1,
      state: $enumDecodeNullable(_$CowStateEnumMap, json['state']) ??
          CowState.Lactation,
      lastInsemination: json['lastInsemination'] == null
          ? null
          : DateTime.parse(json['lastInsemination'] as String),
      lastCalving: json['lastCalving'] == null
          ? null
          : DateTime.parse(json['lastCalving'] as String),
      note: json['note'] as String? ?? '',
      farmId: json['farmId'] as int? ?? 0,
      meanProduction: (json['meanProduction'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$CowToJson(Cow instance) => <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'identification': instance.identification,
      'birthDate': instance.birthDate?.toIso8601String(),
      'bcs': instance.bcs,
      'state': _$CowStateEnumMap[instance.state]!,
      'lastInsemination': instance.lastInsemination?.toIso8601String(),
      'lastCalving': instance.lastCalving?.toIso8601String(),
      'note': instance.note,
      'farmId': instance.farmId,
      'meanProduction': instance.meanProduction,
    };

const _$CowStateEnumMap = {
  CowState.Growth: 'Growth',
  CowState.Dry: 'Dry',
  CowState.Pregnant: 'Pregnant',
  CowState.Lactation: 'Lactation',
  CowState.Death: 'Death',
};
