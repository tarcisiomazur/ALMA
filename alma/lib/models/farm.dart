// -- farm.dart --
import 'package:json_annotation/json_annotation.dart';

part 'farm.g.dart';

@JsonSerializable()
class Farm {
  int id;
  String deviceId;
  String propertyName;

  Farm(this.id,
      this.deviceId,
      this.propertyName,);

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);

  Map<String, dynamic> toJson() => _$FarmToJson(this);
}
