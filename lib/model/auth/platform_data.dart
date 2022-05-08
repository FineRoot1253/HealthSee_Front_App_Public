import 'package:json_annotation/json_annotation.dart';

part 'platform_data.g.dart';

@JsonSerializable()
class PlatformData {
  String name;
  String email;
  String platform;
  String type = "Phone";

  PlatformData(this.email, this.platform, [this.name]);

  factory PlatformData.fromJson(Map<String, dynamic> json) =>
      _$PlatformDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlatformDataToJson(this);
}
