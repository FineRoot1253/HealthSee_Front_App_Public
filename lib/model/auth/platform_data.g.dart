// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformData _$PlatformDataFromJson(Map<String, dynamic> json) {
  return PlatformData(
    json['email'] as String,
    json['platform'] as String,
    json['name'] as String,
  );
}

Map<String, String> _$PlatformDataToJson(PlatformData instance) =>
    <String, String>{
      'email': instance.email,
      'platform': instance.platform.toString(),
      'name': instance.name,
      'type': instance.type,
    };
