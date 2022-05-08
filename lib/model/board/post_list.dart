import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_list.g.dart';

@JsonSerializable()
class PostL {
  final int code;
  final String title;
  final String createAt;
  final int hit;
  final int reportCount;
  final int healthseeCount;
  final int commentCount;
  final String nickname;
  final int state;

  PostL(this.code, this.title, this.createAt, this.hit, this.reportCount,
      this.healthseeCount, this.commentCount, this.nickname, this.state);

  factory PostL.fromJson(Map<String, dynamic> json) => _$PostLFromJson(json);

  Map<String, dynamic> toJson() => _$PostLToJson(this);
}
