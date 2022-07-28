// -- cow.dart --
import 'package:json_annotation/json_annotation.dart';

import 'farm.dart';


part 'cow.g.dart';

@JsonSerializable()
class Cow {
  int id;
  String tag;
  int weight;
  DateTime? birthDate;
  DateTime? deathDate;
  Farm? farm;

  Cow({this.id = 0,
    this.tag = "",
    this.weight = 0,
    this.birthDate,
    this.deathDate,
    this.farm});

  factory Cow.fromJson(Map<String, dynamic> json) => _$CowFromJson(json);

  Map<String, dynamic> toJson() => _$CowToJson(this);
}
