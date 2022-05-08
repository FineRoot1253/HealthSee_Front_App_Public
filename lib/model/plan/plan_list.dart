import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan_list.g.dart';

@JsonSerializable()
class PlanList{
  int code;
  String nickname;
  String title;
  String createAt;
  List<dynamic> routin;
  int scope;
  int healthseeCount;
  int reportCount;
  int evaluationCount;

  PlanList({
    this.code,
    this.nickname,
    this.title,
    this.createAt,
    this.routin,
    this.scope,
    this.healthseeCount,
    this.reportCount,
    this.evaluationCount
});

  factory PlanList.fromJson(Map<String, dynamic> json) => _$PlanListFromJson(json);

  Map<String, dynamic> toJson() => _$PlanListToJson(this);
}