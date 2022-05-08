// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'post_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostL _$PostLFromJson(Map<String, dynamic> json) {
  return PostL(
      json['BO_Code'] as int,
      json['BO_Title'] as String,
      DateFormat("yyyy-MM-dd HH:mm").format(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(json['BO_Creation_Date'])
          .toLocal()),
      json['BO_Hit'] as int,
      json['BO_Report_Count'] as int,
      json['BO_Healthsee_Count'] as int,
      json['BO_Comment_Count'] as int,
      json['BO_Writer_NickName'] as String,
      json['BO_State'] as int);
}

Map<String, dynamic> _$PostLToJson(PostL instance) => <String, dynamic>{
      'BO_Code': instance.code,
      'BO_Title': instance.title,
      'BO_Creation_Date': instance.createAt,
      'BO_Hit': instance.hit,
      'BO_Report_Count': instance.reportCount,
      'BO_Healthsee_Count': instance.healthseeCount,
      'BO_Comment_Count': instance.commentCount,
      'BO_Writer_NickName': instance.nickname,
      'BO_State': instance.state
    };
