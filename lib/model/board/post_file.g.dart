// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'post_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFile _$PostFileFromJson(Map<String, dynamic> json) {
  return PostFile(
    json['BF_Code'] as int,
    json['BF_Name'] as String,
    json['BF_Type'] as String,
    json['Board_BO_Code'] as int,
  );
}

Map<String, dynamic> _$PostFileToJson(PostFile instance) => <String, dynamic>{
      'BF_Code': instance.code,
      'BF_Name': instance.name,
      'BF_Type': instance.type,
      'Board_BO_Code': instance.ref_code,
    };
