import 'dart:io';
import 'package:heathee/model/album/a_comment.dart';
import 'package:heathee/model/album/picture.dart';
import 'package:json_annotation/json_annotation.dart';
part 'album_detail.g.dart';

@JsonSerializable()
class Album {
  int code;
  String nickname;
  String AL_Creation_Date;
  List<dynamic> AL_Picture=List<dynamic>();
  int AL_Scope;
  String AL_Content;
  List<A_Comment> AL_Comments = [];
  bool isChoosePage = false;
  List<Picture> A_Picture;

  Album(
      {this.code,
      this.nickname,
      this.AL_Creation_Date,
      this.AL_Picture,
      this.AL_Scope,
      this.AL_Comments,
      this.AL_Content});
  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
