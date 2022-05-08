import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_detail.g.dart';

@JsonSerializable()
class PostDetail {
  int code;
  String title; // 글제목
  String nickname; // 작성자
  List<dynamic> file; // 첨부파일
  String content; //
  String createAt;
  int hit;
  int reportCount;
  int healthseeCount;
  int commentCount;

  PostDetail(
    this.title,
    this.content,
    this.reportCount,
    this.healthseeCount,
    this.commentCount,
    this.nickname,
    this.file,
    this.hit,
    this.createAt,
    this.code,
  );

  factory PostDetail.fromJson(Map<String, dynamic> json) =>
      _$PostDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailToJson(this);
}
