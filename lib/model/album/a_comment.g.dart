// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'a_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

A_Comment _$A_CommentFromJson(Map<String, dynamic> json) {
  return A_Comment(
    json['ACO_Code'] as int,
    json['ACO_Content'] as String,
    json['ACO_Creation_Date'] as String,
    json['ACO_State'] as int,
    json['ACO_Writer_NickName'] as String,
    json['Album_AL_Code'] as int,
    json['Album_Account_AC_NickName'] as String,
  );
}

Map<String, dynamic> _$A_CommentToJson(A_Comment instance) => <String, dynamic>{
      'ACO_Code': instance.code,
      'ACO_Writer_NickName': instance.nickname,
      'ACO_Content': instance.content,
      'ACO_State' : instance.state,
      'ACO_Creation_Date': instance.createAt,
      'Album_AL_Code': instance.boardCode,
      'Album_Account_AC_NickName': instance.Album_Account_AC_NickName,
    };
