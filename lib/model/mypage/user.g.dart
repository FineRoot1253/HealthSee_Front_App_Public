// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['ME_Code'] as int,
    json['Account_AC_NickName'] as String,
    json['ME_Scope'] as int,
    (json['ME_Profile_Photo'] != null)
        ? Uint8List.fromList(json['ME_Profile_Photo']['data'].cast<int>())
        : null,
    (json['ME_Profile_Photo'] != null) ? json['ME_Profile_Type'] : null,
    json['ME_Gender'] as int,
    json['ME_Weight'] as num,
    json['ME_Height'] as num,
    json['ME_Board_Count'] as int,
    json['ME_Album_Count'] as int,
    (json['ME_Birth'] != null)
        ? DateFormat("yyyy-MM-dd").format(
            DateFormat("yyyy-MM-dd").parseUTC(json['ME_Birth']).toLocal())
        : "1997-01-01",
  );
}

//Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
//  'BC_Code': instance.code,
//  'BC_Writer_NickName': instance.nickname,
//  'BC_Content': instance.content,
//  'BC_Creation_Date': instance.createAt,
//  'BC_Report_Count': instance.reportCount,
//  'BC_Re_Ref': instance.reRef,
//  'Board_BO_Code': instance.boardCode,
//  'BC_State': instance.state
//};
