import 'package:json_annotation/json_annotation.dart';
part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int code;
  String nickname;
  String content;
  String createAt;
  int reportCount;
  int reRef;
  int boardCode;
  bool isReply = false;

  ///상태
  int state;

  Comment(this.code, this.content, this.createAt, this.reRef, this.boardCode,
      this.nickname, this.reportCount, this.state);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
