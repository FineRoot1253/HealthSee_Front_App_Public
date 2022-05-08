import 'dart:convert';

import 'package:heathee/model/plan/plan_evaluation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan_detail.g.dart';

@JsonSerializable()
class Plan {
  int code;
  String writer_NickName;
  String title;
  int restTIme;
  String description;
  String createAt;
  List<dynamic> routin;
  int scope;
  int evaluationCount;
  int healthseeCount;
  int reportCount;



  Plan(
      {this.code,
      this.writer_NickName,
      this.title,
      this.restTIme,
      this.description,
      this.createAt,
      this.routin,
      this.scope,
      this.evaluationCount,
      this.healthseeCount,
      this.reportCount
      });

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  Map<String, dynamic> toJson() => _$PlanToJson(this);
}
