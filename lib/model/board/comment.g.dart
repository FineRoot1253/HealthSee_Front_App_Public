// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
      json['BC_Code'] as int,
      json['BC_Content'] as String,
      json['BC_Creation_Date'] as String,
      json['BC_Re_Ref'] as int,
      json['Board_BO_Code'] as int,
      json['BC_Writer_NickName'] as String,
      json['BC_Report_Count'] as int,
      json['BC_State'] as int);
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'BC_Code': instance.code,
      'BC_Writer_NickName': instance.nickname,
      'BC_Content': instance.content,
      'BC_Creation_Date': instance.createAt,
      'BC_Report_Count': instance.reportCount,
      'BC_Re_Ref': instance.reRef,
      'Board_BO_Code': instance.boardCode,
      'BC_State': instance.state
    };
