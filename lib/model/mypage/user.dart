import 'dart:io';

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';
part 'user.g.dart';

@JsonSerializable()
class User {
  int code;
  String nickname;
  num weight;
  num height;
  String birth;
  int gender;
  int scope;
  int boardCount;
  int albumCount;
  Uint8List picture;
  String picture_type;
  File tempProfileImage = null;
  File nowProfileImage = null;
  //int attendanceCount;

  User(this.code, this.nickname, this.scope, this.picture, this.picture_type,
      [this.gender,
      this.weight,
      this.height,
      this.boardCount,
      this.albumCount,
      this.birth]);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  //Map<String, dynamic> toJson() => _$UserToJson(this);
  // Map<String, dynamic> toJson() => _$UserToJson(this);
}
