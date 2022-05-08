import 'package:json_annotation/json_annotation.dart';

part 'plan_evaluation.g.dart';

class PlanEvaluation{
  int code;
  String nickname;
  int state;
  String content;
  String createAt;
  int planCode;
  int reportCount = 0;
  int boardCode;

  PlanEvaluation(
    this.code,
    this.nickname,
    this.content,
    this.createAt,
    this.planCode,
    this.state,
    this.reportCount
);
  factory PlanEvaluation.fromJson(Map<String, dynamic> json) => _$PlanEvaluationFromJson(json);

  Map<String, dynamic> toJson() => _$PlanEvaluationToJson(this);
}