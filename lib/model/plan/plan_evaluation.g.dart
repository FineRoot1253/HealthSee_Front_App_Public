// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_evaluation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanEvaluation _$PlanEvaluationFromJson(Map<String, dynamic> json) {
  return PlanEvaluation(
    json['PEV_Code'] as int,
    json['PEV_Writer_NickName'] as String,
    json['PEV_Content'] as String,
    json['PEV_Creation_Date'] as String,
    json['Plan_PL_Code'] as int,
    json['PEV_State'] as int,
    json['PRE_Report_Count'] as int,
  );
}

Map<String, dynamic> _$PlanEvaluationToJson(PlanEvaluation instance) =>
    <String, dynamic>{
      'code': instance.code,
      'nickname': instance.nickname,
      'state': instance.state,
      'content': instance.content,
      'createAt': instance.createAt,
      'reportCount': instance.reportCount,
      'planCode': instance.planCode,
    };
