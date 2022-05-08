import 'package:json_annotation/json_annotation.dart';

part 'a_comment.g.dart';

@JsonSerializable()

class A_Comment {
  int code;
  String nickname;
  String content;
  String createAt;
  int boardCode;
  int state;
  String Album_Account_AC_NickName;
  int reportCount = 0;
  A_Comment(
      this.code,
      this.content,
      this.createAt,
      this.state,
      this.nickname,
      this.boardCode,
      this.Album_Account_AC_NickName);

  factory A_Comment.fromJson(Map<String, dynamic> json) =>
      _$A_CommentFromJson(json);

  Map<String, dynamic> toJson() => _$A_CommentToJson(this);
}