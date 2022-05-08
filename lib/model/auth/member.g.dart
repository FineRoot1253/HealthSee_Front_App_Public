// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
      json['name'] as String,
      json['email'] as String,
      json['platform'] as String,
      json['nickname'] as String,
      json['type'] as String,
      json['scope'] as int,
      json['gender'] as int,
      json['weight'] as double);
}

Map<String, String> _$MemberToJson(Member instance) => <String, String>{
      'nickname': instance.nickname,
      'weight': instance.weight.toString(),
      'name': instance.name,
      'email': instance.email,
      'platform': instance.platform,
      'type': instance.type,
      'scope': instance.scope.toString(),
      'gender': instance.gender.toString(),
    };
