// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'post_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetail _$PostDetailFromJson(Map<String, dynamic> json) {
  return PostDetail(
    json['BO_Title'] as String,
    json['BO_Content'] as String,
    json['BO_Report_Count'] as int,
    json['BO_Healthsee_Count'] as int,
    json['BO_Comment_Count'] as int,
    json['BO_Writer_NickName'] as String,
    json['BO_File'] as List<dynamic>,
    json['BO_Hit'] as int,
    DateFormat("yyyy-MM-dd HH:mm").format(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
        .parseUTC(json['BO_Creation_Date'] as String)
        .toLocal()),
    json['BO_Code'] as int,
  );
}

Map<String, dynamic> _$PostDetailToJson(PostDetail instance) =>
    <String, dynamic>{
      'BO_Code': instance.code,
      'BO_Title': instance.title,
      'BO_Writer_NickName': instance.nickname,
      'BO_File': instance.file,
      'BO_Content': instance.content,
      'BO_Creation_Date': instance.createAt,
      'BO_Hit': instance.hit,
      'BO_Report_Count': instance.reportCount,
      'BO_Healthsee_Count': instance.healthseeCount,
      'BO_Comment_Count': instance.commentCount,
    };
