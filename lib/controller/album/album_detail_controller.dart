import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heathee/api/timeset.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/album/a_comment.dart';
import 'package:heathee/model/album/album_detail.dart';
import 'dart:io';
import 'package:heathee/model/album/picture.dart';
import 'package:heathee/model/util/error.dart';


class AlbumDetailController extends GetxController {
  Album detail = Album();

  List<dynamic> pictures = [];
  List<File> uploadFileList = [];
  List<A_Comment> comments = [];
  int commentCount;
  int pictureCount;
  int nowPage = 1;
  int lastPage;
  bool isLoading = false;
  Future<dynamic> resultList;
  HttpController httpController = Get.put(HttpController());

  get getAlbumPicutureFileList => detail.AL_Picture;
  get getAlbumPicutureList => detail.A_Picture;
  get getAlbumDetail => detail;

  AlbumDetailController({this.detail});

  setAlbumDetail({List<File> AL_Picture, String AL_Content, int AL_Scope}) {
    print(AL_Picture.length);
    this.detail.AL_Picture = AL_Picture;
    this.detail.AL_Content = AL_Content;
    this.detail.AL_Scope = AL_Scope;
    update();
  }

  postAlbum(
      {String Account_AC_NickName,
      String AL_Content,
      String AL_Scope,
      List<File> AL_Picture}) async {
    Map<String, String> fields = {
      'Account_AC_NickName': Account_AC_NickName,
      'AL_Content': AL_Content,
      'AL_Scope': AL_Scope.toString(),
    };

    var response = await httpController.StartUploading(
        'POST', 'http://$IP$ALBUMPOST',
        uploadFiles: AL_Picture, fields: fields);

    this.detail = Album.fromJson(response['albumDetail']);
    this.detail.AL_Picture = [];
    this.detail.A_Picture = [];
    Uint8List uint8list = Uint8List.fromList(
        response['picture']['AP_Picture']['data'].cast<int>());
    pictureCount = response['picturesCount'];
    this.detail.AL_Picture.add(uint8list);
    this.detail.A_Picture = List<Picture>(pictureCount);
    this.detail.A_Picture[0] = Picture(
        Album_AL_Code: detail.code,
        AL_Picture: Image.memory(uint8list),
        AL_Picture_Types: response['picture']['AP_Picture_Type'],
        AP_Code: response['picture']['AP_Code']);
    List<A_Comment> a_CommentList = parsingComment(response['comments']);
    pictureCount = response['picturesCount'];
    commentCount = response['commentsCount'];
    this.detail.AL_Creation_Date = timeSet(this.detail.AL_Creation_Date);
    onlyCommentReplace(a_CommentList);
    lastPage = response['lastPage'];
    isLoading = false;
    MyPageController.to.myUserIsChanged = true;
    Get.offNamed('/albumChosen', arguments: this);
  }

  //사진 읽어오기
  readPicture(int AP_Code, int index) async {
    if (!this.isLoading) {
      this.isLoading = true;
      var response = await httpController.httpManeger(
          "GET", 'http://$IP$ALBUMPOST/picture/$AP_Code&${detail.code}');
      Uint8List uint8list =
          Uint8List.fromList(response['AP_Picture']['data'].cast<int>());
      this.detail.AL_Picture.add(uint8list);
      this.detail.A_Picture[index] = Picture(
          Album_AL_Code: detail.code,
          AL_Picture: Image.memory(uint8list),
          AL_Picture_Types: response['AP_Picture_Type'],
          AP_Code: response['AP_Code']);
      this.isLoading = false;
    }
  }

  //앨범 읽어오기
  readAlbum(int AL_Code) async {
    var response = await httpController.httpManeger(
        "GET", 'http://$IP$ALBUMPOST/$AL_Code');

    print("디테일 받기 성공");

    this.detail = Album.fromJson(response['albumDetail']);
    this.detail.AL_Picture = [];
    this.detail.A_Picture = [];
    Uint8List uint8list = Uint8List.fromList(
        response['picture']['AP_Picture']['data'].cast<int>());
    pictureCount = response['picturesCount'];
    this.detail.AL_Picture.add(uint8list);
    this.detail.A_Picture = List<Picture>(pictureCount);
    this.detail.A_Picture[0] = Picture(
        Album_AL_Code: detail.code,
        AL_Picture: Image.memory(uint8list),
        AL_Picture_Types: response['picture']['AP_Picture_Type'],
        AP_Code: response['picture']['AP_Code']);

    List<A_Comment> a_CommentList = parsingComment(response['comments']);
    lastPage = response['lastPage'];

    commentCount = response['commentsCount'];
    print(a_CommentList.length);
    this.detail.AL_Creation_Date = timeSet(this.detail.AL_Creation_Date);
    onlyCommentReplace(a_CommentList);
    isLoading = false;
  }

  updateAlbum(
      {List<File> pictures,
      String AL_Content,
      int AL_Scope,
      String leavePicture}) async {
    Map<String, String> fields = {
      "Account_AC_NickName": detail.nickname,
      "AL_Content": AL_Content,
      "AL_Scope": AL_Scope.toString(),
      "leaveFile": (leavePicture != null) ? leavePicture : ""
    };

    var response = await httpController.StartUploading(
        'PATCH', 'http://$IP$ALBUMPOST/${detail.code}',
        fields: fields, uploadFiles: pictures);
    this.detail = Album.fromJson(response['albumDetail']);

    this.detail.AL_Picture = [];
    this.detail.A_Picture = [];
    Uint8List uint8list = Uint8List.fromList(
        response['picture']['AP_Picture']['data'].cast<int>());
    pictureCount = response['picturesCount'];
    this.detail.AL_Picture.add(uint8list);
    this.detail.A_Picture = List<Picture>(pictureCount);
    this.detail.A_Picture[0] = Picture(
        Album_AL_Code: detail.code,
        AL_Picture: Image.memory(uint8list),
        AL_Picture_Types: response['picture']['AP_Picture_Type'],
        AP_Code: response['picture']['AP_Code']);

    List<A_Comment> a_CommentList = parsingComment(response['comments']);
    lastPage = response['lastPage'];
    commentCount = response['commentsCount'];
    this.detail.AL_Creation_Date = timeSet(this.detail.AL_Creation_Date);
    onlyCommentReplace(a_CommentList);
    print("보내기전 길이 : " + this.detail.AL_Picture.length.toString());
    AlbumMainController.to.update();
    update();
    this.isLoading = false;
    Get.back();
  }

  deleteAlbum(int index, String nickname) async {
    var res = await HttpController.to
        .httpManeger("DELETE", "http://$IP$ALBUMPOST/$index");
    MyPageController.to.myUserIsChanged = true;
    AlbumMainController.to.update();
  }

  parsingComment(comments) {
    isLoading = true;
    print("파싱맨");
    List<A_Comment> commentList = <A_Comment>[];

    for (var co in comments) {
      print("파싱시작 : ${co['ACO_State']}");
      try{A_Comment comment = A_Comment(
          co['ACO_Code'],
          co['ACO_Content'],
          co['ACO_Creation_Date'],
          co['ACO_State'],
          co['ACO_Writer_NickName'],
          co['Album_AL_Code'],
          co['Album_Account_AC_NickName']);
      commentList.add(comment);
      print("${comment.state}");
      }catch(e){
        print("$e");
      }
    }
    return commentList;
  }

  // 댓글만 새로고침
  onlyCommentReplace(List<A_Comment> comments) {
    this.comments = [];
    this.comments.addAll(comments);
  }

  writeComment(String ACO_Content, int Album_AL_Code, [int BC_Re_Ref]) async {
    isLoading = true;
    var page = (BC_Re_Ref == null) ? 1 : nowPage;
    var response = await httpController
        .httpManeger("POST", 'http://$IP$ALBUMCOMMENT/$Album_AL_Code', {
      'ACO_Content': ACO_Content,
      'Album_AL_Code': Album_AL_Code.toString(),
      'Album_Account_AC_NickName': detail.nickname,
      'page': page.toString()
    });
    List<A_Comment> a_CommentList = parsingComment(response['comments']);
    commentCount = response['commentsCount'];
    lastPage = response['lastPage'];
    nowPage = page;
    onlyCommentReplace(a_CommentList);
    update();
    isLoading = false;
  }

  updateComments(String ACO_Content, int ACO_Code) async {
    isLoading = true;
    var response = await httpController.httpManeger(
        "PATCH",
        'http://$IP$ALBUMCOMMENT/${this.detail.code.toString()}',
        {'ACO_Content': ACO_Content, 'ACO_Code': ACO_Code.toString()});

    List<A_Comment> commentList = parsingComment(response['comments']);
    onlyCommentReplace(commentList);
    update();
    isLoading = false;
  }

  removeComment(int Album_AL_Code, int code) async {
    isLoading = true;
    var response = await httpController.httpManeger(
        "DELETE", 'http://$IP$ALBUMCOMMENT/$Album_AL_Code&${code}&${nowPage}');
    this.comments.removeWhere((element) => element.code == code);
    List<A_Comment> commentList = parsingComment(response['comments']);
    commentCount = response['commentsCount'];
    lastPage = response['lastPage'];
    onlyCommentReplace(commentList);
    update();
    isLoading = false;
  }

  getPageComment(int AL_Code, int page) async {
    isLoading = true;
    var url = 'http://$IP$ALBUMCOMMENT/$AL_Code&${page}';
    var responseData = await HttpController.to.httpManeger("GET", url);
    List<A_Comment> commentList = parsingComment(responseData['comments']);
    commentCount = responseData['commentsCount'];
    lastPage = responseData['lastPage'];
    onlyCommentReplace(commentList);
    nowPage = page;
    update();
    isLoading = false;
  }

  clickReportComment(int ACO_Code, int nowPage) async {
    if (this.isLoading) return;
    String name;
    comments.where((e) => e.code == ACO_Code).forEach((element) {name = element.nickname;});
    var url = 'http://$IP$ALBUMCOMMENT/report/${detail.code}';
    var body = {
      'Album_AL_Code': detail.code.toString(),
      'A_Comment_ACO_Code': ACO_Code.toString(),
      'page': nowPage.toString(),
      'ACO_Writer_NickName':name
    };
    this.isLoading = true;
    var responseData = await HttpController.to.httpManeger("POST", url, body);

    if (responseData == 409) {
      this.isLoading = false;
      throw DuplicationException();
    } else {
      List<A_Comment> commentList = parsingComment(responseData['comments']);
      commentCount = responseData['commentsCount'];
      lastPage = responseData['lastPage'];
      onlyCommentReplace(commentList);
      this.nowPage = nowPage;
      this.isLoading = false;
      update();
    }
  }
}
