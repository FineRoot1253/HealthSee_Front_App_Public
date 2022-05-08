// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) {
  return Album(
    code: json['AL_Code'] as int,
    nickname: json['Account_AC_NickName'] as String,
    AL_Creation_Date: json['AL_Creation_Date'] as String,
    AL_Picture: json['AL_Picture'] as List,
    AL_Scope: json['AL_Scope'] as int,
    AL_Content: json['AL_Content'] as String,
  )..AL_Comments = (json['AL_Comments'] as List)
      ?.map((e) =>
          e == null ? null : A_Comment.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'code': instance.code,
      'Account_AC_NickName': instance.nickname,
      'AL_Creation_Date': instance.AL_Creation_Date,
      'AL_Picture': instance.AL_Picture,
      'AL_Scope': instance.AL_Scope,
      'AL_Content': instance.AL_Content,
      'AL_Comments': instance.AL_Comments,
    };
