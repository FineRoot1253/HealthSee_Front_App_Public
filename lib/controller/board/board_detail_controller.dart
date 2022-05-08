import 'dart:io';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:heathee/controller/mypage/mypage_search_controller.dart';
import 'package:heathee/model/board/post_detail.dart';
import 'package:get/get.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/board/comment.dart';
import 'package:heathee/model/board/post_file.dart';
import 'package:heathee/model/util/error.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PostDetailController extends GetxController {
  static PostDetailController get to => Get.find();
  PostDetail detail;
  // 파일로 변경하기 전의 블롭 배열
  List<PostFile> fileList = [];
  List<Comment> comments = [];
  int commentCount;
  int nowPage = 1;
  int lastPage;
  bool isHealthsee = false;
  bool isReport = false;
  bool isLoading = false;

  PostDetailController(
      [this.detail,
      this.comments,
      this.fileList,
      this.lastPage,
      this.isHealthsee,
      this.isReport,
      this.commentCount]);

  // 게시글 작성에서 게시글 디테일 얻어올 때
  writePostDetail(
      String title, List<File> files, String nickName, String content) async {
    var url = 'http://$IP$BOARDPOST';
    Map<String, String> fields = {
      "BO_Title": title,
      "username": nickName,
      "BO_Content": content,
    };

    var responseData = await HttpController.to
        .StartUploading("POST", url, uploadFiles: files, fields: fields);
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      throw BlindPostException();
    }
    this.detail = PostDetail.fromJson(responseData['boardDetail']);
    fileList = parsingFile(responseData['boardFile']);
    lastPage = responseData['lastPage'];
    comments = parsingComment(responseData['comments']);
    commentCount = responseData['commentsCount'];
    isReport = (responseData['isReport'] == 0) ? false : true;
    isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
    isLoading = false;
    MyPageController.to.myUserIsChanged = true;
    Get.offNamed('/boardDetail', arguments: this);
  }

  // 게시글 목록에서 게시글 디테일 얻어올 때
  readPostDetail(int BO_Code) async {
    var url = 'http://$IP$BOARDPOST/$BO_Code';
    var responseData = await HttpController.to.httpManeger("GET", url);
    if (responseData == 'blind') {
      throw BlindPostException();
    } else {
      print(responseData);

      this.detail = PostDetail.fromJson(responseData['boardDetail']);
      fileList = parsingFile(responseData['boardFile']);
      lastPage = responseData['lastPage'];
      comments = parsingComment(responseData['comments']);
      commentCount = responseData['commentsCount'];
      isReport = (responseData['isReport'] == 0) ? false : true;
      isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
      isLoading = false;
      Get.toNamed("/boardDetail", arguments: this);
    }
  }

  deletePost(int code) async {
    var responseData = await HttpController.to
        .httpManeger("DELETE", 'http://$IP$BOARDPOST/$code}');
    if (responseData['result'] == 1) {
      MyPageController.to.myUserIsChanged = true;
      Get.back();
    } else
      Get.snackbar("삭제 실패", "삭제 실패");
  }

  updatePost(
      {String title,
      List<File> uploadFiles,
      String content,
      String leaveFile}) async {
    var url = 'http://$IP$BOARDPOST/${detail.code}';
    Map<String, String> fields = {
      "BO_Code": detail.code.toString(),
      "BO_Title": title,
      "username": detail.nickname,
      "BO_Content": content,
      "leaveFile": (leaveFile != null) ? leaveFile : ""
    };
    var responseData = await HttpController.to
        .StartUploading("PATCH", url, uploadFiles: uploadFiles, fields: fields);
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    }

    detail = PostDetail.fromJson(responseData['boardDetail']);
    fileList = parsingFile(responseData['boardFile']);
    lastPage = responseData['lastPage'];
    comments = parsingComment(responseData['comments']);
    commentCount = responseData['commentsCount'];
    isReport = (responseData['isReport'] == 0) ? false : true;
    isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
    isLoading = false;
    Get.offNamed('/boardDetail', arguments: this);
//    return Detail;
  }

  // 게시글
  refreshPost() async {
    this.isLoading = true;
    var url = 'http://$IP$BOARDPOST/${detail.code}';
    var responseData = await HttpController.to.httpManeger("GET", url);
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    } else {
      this.replaceWith(PostDetail.fromJson(responseData['boardDetail']));
      this.lastPage = responseData['lastPage'];
      List<Comment> commentList = parsingComment(responseData['comments']);
      this.onlyCommentReplace(commentList);
      isReport = (responseData['isReport'] == 0) ? false : true;
      isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
      isLoading = false;
      update();
    }
  }

  clickReportComment(int BC_Code, int nowPage) async {
    if (this.isLoading) return;

    var url = 'http://$IP$BOARDCOMMENT/report';
    var body = {
      'Board_BO_Code': detail.code.toString(),
      'B_Comment_BC_Code': BC_Code.toString(),
      'page': nowPage.toString()
    };
    this.isLoading = true;
    var responseData = await HttpController.to.httpManeger("POST", url, body);

    if (responseData == 409) {
      this.isLoading = false;
      throw DuplicationException();
    } else {
      List<Comment> commentList = parsingComment(responseData['comments']);
      commentCount = responseData['commentsCount'];
      lastPage = responseData['lastPage'];
      onlyCommentReplace(commentList);
      this.nowPage = nowPage;
      update();
      isLoading = false;
    }
  }

  // 게시글 신고 기능
  clickReport(int BO_Code) async {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;
    var responseData = await HttpController.to.httpManeger(
        "POST", 'http://$IP$BOARDREPORT', {'BO_Code': BO_Code.toString()});
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    } else {
      isReport = responseData['isReport'];
      this.detail.reportCount = responseData['BO_Report_Count'];
      update();
      this.isLoading = false;
    }
  }

  // 게시글 추천 기능
  clickHealthsee(int BO_Code) async {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;

    var responseData = await HttpController.to.httpManeger(
        "POST", 'http://$IP$BOARDHEALTHSEE', {'BO_Code': BO_Code.toString()});
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    } else {
      isHealthsee = responseData['isHealthsee'];
      this.detail.healthseeCount = responseData['BO_Healthsee_Count'];
      update();
      this.isLoading = false;
    }
  }

  // 게시글 새로 고침
  replaceWith(postDetail) {
    if (postDetail == null) return;
    this.detail = postDetail;
  }

  // 댓글만 새로고침
  onlyCommentReplace(List<Comment> comments) {
    this.comments = [];
    this.comments.addAll(comments);
  }

  // 댓글 작성
  writeComment(String BC_Content, int Board_BO_Code, [int BC_Re_Ref]) async {
    isLoading = true;
    var page = (BC_Re_Ref == null) ? 1 : nowPage;
    var url = 'http://$IP$BOARDCOMMENT';
    var body = {
      'BC_Content': BC_Content,
      'Board_BO_Code': Board_BO_Code.toString(),
      'BC_Re_Ref': (BC_Re_Ref != null) ? BC_Re_Ref.toString() : 0.toString(),
      'page': page.toString()
    };
    var responseData = await HttpController.to.httpManeger("POST", url, body);
    List<Comment> commentList = parsingComment(responseData['comments']);
    commentCount = responseData['commentsCount'];
    lastPage = responseData['lastPage'];
    nowPage = page;
    onlyCommentReplace(commentList);
    update();
    isLoading = false;
  }

  updateComments(String BC_Content, int BC_Code) async {
    isLoading = true;
    var url = 'http://$IP$BOARDCOMMENT';
    var body = {
      'BC_Content': BC_Content,
      'page': nowPage.toString(),
      'BC_Code': BC_Code.toString()
    };

    var responseData = await HttpController.to.httpManeger("PATCH", url, body);

    List<Comment> commentList = parsingComment(responseData['comments']);
    commentCount = responseData['commentsCount'];
    lastPage = responseData['lastPage'];
    onlyCommentReplace(commentList);
    update();
    isLoading = false;
  }

  // 댓글 삭제
  removeComment(int code) async {
    isLoading = true;
    var url = 'http://$IP$BOARDCOMMENT/${code}&${nowPage}';
    var responseData = await HttpController.to.httpManeger("delete", url);
    this.comments.removeWhere((element) => element.code == code);
    List<Comment> commentList = parsingComment(responseData['comments']);
    commentCount = responseData['commentsCount'];
    lastPage = responseData['lastPage'];
    onlyCommentReplace(commentList);
    update();
    isLoading = false;
  }

  // 댓글 파싱
  parsingComment(comments) {
    isLoading = true;
    List<Comment> commentList = <Comment>[];

    for (var co in comments) {
      Comment comment = Comment(
          co['BC_Code'],
          co['BC_Content'],
          DateFormat("yyyy-MM-dd HH:mm").format(
              DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                  .parseUTC(co['BC_Creation_Date'])
                  .toLocal()),
          co['BC_Re_Ref'],
          co['Board_BO_Code'],
          co['BC_Writer_NickName'],
          co['BC_Report_Count'],
          co['BC_State']);
      commentList.add(comment);
    }
    return commentList;
  }

  parsingFile(files) {
    isLoading = true;
    List<PostFile> fileList = <PostFile>[];

    for (var fi in files) {
      print(fi['BF_Name']);
      PostFile file = PostFile(
          fi['BF_Code'], fi['BF_Name'], fi['BF_Type'], fi['Board_BO_Code']);
      fileList.add(file);
    }
    return fileList;
  }

  getPageComment(int BO_Code, int page) async {
    isLoading = true;
    var url = 'http://$IP$BOARDCOMMENT/$BO_Code&${page}';
    var responseData = await HttpController.to.httpManeger("GET", url);
    List<Comment> commentList = parsingComment(responseData['comments']);
    commentCount = responseData['commentsCount'];
    lastPage = responseData['lastPage'];
    onlyCommentReplace(commentList);
    nowPage = page;
    update();
    isLoading = false;
  }
}

// -------------------- ↑ 모듈화
