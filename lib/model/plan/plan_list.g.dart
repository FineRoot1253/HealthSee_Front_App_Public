// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanList _$PlanListFromJson(Map<String, dynamic> newJson) {
  return PlanList(
      code: newJson['PL_Code'] as int,
      nickname: newJson['PL_Writer_NickName'] as String,
      title: newJson['PL_Title'] as String,
      createAt: DateFormat("yyyy-MM-dd HH:mm").format(DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parseUTC(newJson['PL_Creation_Date'] as String)
          .toLocal()),
      routin: json.decode(newJson['PL_Routin']) as List<dynamic>,
      scope: newJson['PL_Scope'] as int,
      healthseeCount: newJson['P_Healthsee_Count'] as int,
      reportCount: newJson['P_Report_Count'] as int,
    evaluationCount: newJson['P_Evaluation_Count'] as int
  );
}

Map<String, dynamic> _$PlanListToJson(PlanList instance) => <String, dynamic>{
  'code': instance.code,
  'nickname': instance.nickname,
  'createAt': instance.createAt,
  'title': instance.title,
  'routin': instance.routin,
  'scope': instance.scope,
  'healthseeCount': instance.healthseeCount,
  'evaluationCount': instance.evaluationCount,
  'reportCount': instance.reportCount
};
