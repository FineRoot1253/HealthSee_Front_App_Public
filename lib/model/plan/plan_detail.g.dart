// GENERATED CODE - DO NOT MODIFY BY HAND


part of 'plan_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> returnedJson) {
  return Plan(
      code: returnedJson['PL_Code'] as int,
      writer_NickName: returnedJson['PL_Writer_NickName'] as String,
      title: returnedJson['PL_Title'] as String,
      restTIme: returnedJson['PL_RestTIme'] as int,
      description: returnedJson['PL_Description'] as String,
      createAt: returnedJson['PL_Creation_Date'] as String,
      routin:  json.decode(returnedJson['PL_Routin']),
      scope: returnedJson['PL_Scope'] as int,
      evaluationCount: returnedJson['P_Evaluation_Count'] as int,
      healthseeCount: returnedJson['P_Healthsee_Count'] as int,
      reportCount: returnedJson['P_Report_Count'] as int);
}

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'code': instance.code,
      'writer_NickName': instance.writer_NickName,
      'createAt': instance.createAt,
      'title': instance.title,
      'restTIme': instance.restTIme,
      'description': instance.description,
      'routin': instance.routin,
      'scope': instance.scope,
      'evaluationCount': instance.evaluationCount,
      'healthseeCount': instance.healthseeCount,
      'reportCount': instance.reportCount,
    };
