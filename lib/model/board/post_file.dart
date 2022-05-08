import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'post_file.g.dart';

@JsonSerializable()
class PostFile {
  int code;
  String name;
  Uint8List bytes;
  String type;
  int ref_code;

  PostFile(this.code, this.name, this.type, this.ref_code);

  factory PostFile.fromJson(Map<String, dynamic> json) =>
      _$PostFileFromJson(json);

  Map<String, dynamic> toJson() => _$PostFileToJson(this);
}
