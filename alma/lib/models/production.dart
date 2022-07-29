// -- production.dart --
import 'package:json_annotation/json_annotation.dart';

part 'production.g.dart';

@JsonSerializable()
class Production {
  int id;
  DateTime time;
  int cowId;

  Production(this.id,
      this.time,
      this.cowId,);

  factory Production.fromJson(Map<String, dynamic> json) => _$ProductionFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionToJson(this);
}
