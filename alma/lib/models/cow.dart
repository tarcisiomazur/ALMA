// -- cow.dart --
// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'cow.g.dart';

enum CowState{
  Growth,
  Dry,
  Pregnant,
  Lactation,
  Death
}

extension CowStateExtension on CowState {

  String get name {
    switch (this) {
      case CowState.Growth:
        return 'Crescimento';
      case CowState.Dry:
        return 'Secando';
      case CowState.Pregnant:
        return 'Prenha';
      case CowState.Lactation:
        return 'Produção';
      case CowState.Death:
        return 'Morto';
    }
  }

}

@JsonSerializable()
class Cow {
  int id;
  String tag;
  String identification;
  DateTime? birthDate;
  int bcs;
  CowState state;
  DateTime? lastInsemination;
  DateTime? lastCalving;
  String note;
  int farmId;
  double meanProduction;

  Cow({this.id=0, this.tag='', this.identification='', this.birthDate, this.bcs=1, this.state = CowState.Lactation,
      this.lastInsemination, this.lastCalving, this.note='', this.farmId=0, this.meanProduction=0, });

  factory Cow.fromJson(Map<String, dynamic> json) => _$CowFromJson(json);

  Map<String, dynamic> toJson() => _$CowToJson(this);
}
