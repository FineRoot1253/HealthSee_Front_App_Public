import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  String nickname;
  double weight;
  String name;
  String email;
  String platform;
  String type;
  int scope = 0;
  int gender = 0;

  Member(this.nickname, this.email, this.platform,
      [this.name, this.type, this.scope, this.gender, this.weight]);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
