import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/plan/plan_detail.dart';
import 'package:heathee/model/plan/plan_evaluation.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/widget/dialog.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';


class PlanDetailController extends GetxController{

  final ScrollController scrollController = ScrollController();


  static PlanDetailController get to => Get.put(PlanDetailController());
  String value = "편집";
  List<String> valueList = ["편집", "삭제"];

  Plan detail;
  List<PlanEvaluation> comments = [];
  int commentCount;
  int nowPage = 1;
  int lastPage;
  int totalReps=1;
  bool isHealthsee = false;
  bool isReport = false;
  bool isLoading = false;
  bool isCopied = false;

  PlanDetailController({
    this.detail,
    this.commentCount,
    this.comments,
    this.isHealthsee,
    this.isLoading,
    this.isReport,
    this.lastPage,
    this.nowPage
  });
  init(){

  }
  dropDownBtn(String value) async {
    switch (value) {
      case '편집':
        bool result = await yesOrNoDialog('코스 편집','편집하시겠습니까?');
        if(result)
          Get.offNamed('/planEdit', arguments: this);
        break;
      case '삭제':
        bool result = await yesOrNoDialog('코스 삭제','삭제하시겠습니까?');
        if(result)
          await deletePost(this.detail.code);
        break;
    }
  }

  writePostDetail(
  {String title, String nickName, String description, String routin, int scope, int restTime}) async {
    var url = 'http://$IP$PLANPOST';
    Map<String, dynamic> fields = {
      "PL_Title": title,
      "PL_RestTIme": restTime.toString(),
      "PL_Description": description,
      "PL_Routin" : routin,
      "PL_Scope" : scope.toString(),
    };

    var responseData = await HttpController.to.httpManeger("POST", "http://$IP$PLANPOST", fields);
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      throw BlindPostException();
    }
    print(responseData['planDetail']);
    this.detail = Plan.fromJson(responseData['planDetail']);
    lastPage = responseData['lastPage'];
    comments = parsingComment(responseData['evaluations']);
    commentCount = responseData['evaluationsCount'];
    isReport = (responseData['isReport'] == 0) ? false : true;
    isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
    Get.offNamed('/planDetail', arguments: this);
    nowPage = 1;
    isLoading = false;
    print('운동명 : ${this.detail.title}\n'
        '만든이 : ${this.detail.writer_NickName}\n'
        '내용 : ${this.detail.description}\n'
        '운동 종류 : ${this.detail.routin}\n'
        '코드 : ${this.detail.code}\n'
        '만든시각 : ${this.detail.createAt}\n'
        '댓글수 : ${this.detail.evaluationCount}');
  }

  // 게시글 목록에서 게시글 디테일 얻어올 때
  readPostDetail(int PL_Code) async {
    var url = 'http://$IP$PLANPOST/$PL_Code';
    var responseData = await HttpController.to.httpManeger("GET", url);
    if (responseData == 'blind') {
      throw BlindPostException();
    } else {
      print(responseData);

      this.detail = Plan.fromJson(responseData['planDetail']);
      print("디테일 읽어오기 스코프 상태 : ${this.detail.scope}");
      lastPage = responseData['lastPage'];
      comments = parsingComment(responseData['evaluations']);
      commentCount = responseData['evaluationsCount'];
      isReport = (responseData['isReport'] == 0) ? false : true;
      isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
      nowPage = 1;
      isLoading = false;
      print('운동명 : ${this.detail.title}\n'
          '만든이 : ${this.detail.writer_NickName}\n'
          '내용 : ${this.detail.description}\n'
          '운동 종류 : ${this.detail.routin}\n'
          '코드 : ${this.detail.code}\n'
          '만든시각 : ${this.detail.createAt}\n'
          '댓글수 : ${this.detail.evaluationCount}\n'
          '댓댓 현패 : ${this.nowPage}');

//      Get.toNamed("/boardDetail", arguments: this);
    }
  }

  deletePost(int code) async {
    var responseData = await HttpController.to
        .httpManeger("DELETE", 'http://$IP$PLANPOST/${code.toString()}');
    if (responseData['result'] == 1) {
      Get.back();
    } else
      Get.snackbar("삭제 실패", "삭제 실패");
  }

  updatePost(
      {String title,
        String description,
        String routin,
      int restTime,
      int scope}) async {
    var url = 'http://$IP$PLANPOST/${detail.code}';
    Map<String, dynamic> fields = {
      "PL_Code": detail.code.toString(),
      "PL_Title": title,
      "PL_Description": description,
      "PL_RestTIme": restTime.toString(),
      "PL_Routin" : routin,
      "PL_Scope" : scope.toString(),
    };
    var responseData = await HttpController.to.httpManeger("PATCH", "http://$IP$PLANPOST/${detail.code}", fields);
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    }

    detail = Plan.fromJson(responseData['planDetail']);
    lastPage = responseData['lastPage'];
    comments = parsingComment(responseData['evaluations']);
    commentCount = responseData['evaluationsCount'];
    isReport = (responseData['isReport'] == 0) ? false : true;
    isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
    nowPage = 1;
    Get.offNamed('/planDetail', arguments: this);
    isLoading = false;
    print('운동명 : ${this.detail.title}\n'
        '만든이 : ${this.detail.writer_NickName}\n'
        '내용 : ${this.detail.description}\n'
        '운동 종류 : ${this.detail.routin}\n'
        '코드 : ${this.detail.code}\n'
        '만든시각 : ${this.detail.createAt}\n'
        '댓글수 : ${this.detail.evaluationCount}');
//    Get.offNamed('/boardDetail', arguments: this);
//    return Detail;
  }

  // 게시글
  refreshPost() async {
    this.isLoading = true;
    var url = 'http://$IP$PLANPOST/${detail.code}';
    var responseData = await HttpController.to.httpManeger("GET", url);
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    } else {
      this.replaceWith(Plan.fromJson(responseData['planDetail']));
      this.lastPage = responseData['lastPage'];
      List<PlanEvaluation> evaluationList = parsingComment(responseData['evaluations']);
      this.onlyCommentReplace(evaluationList);
      isReport = (responseData['isReport'] == 0) ? false : true;
      isHealthsee = (responseData['isHealthsee'] == 0) ? false : true;
      isLoading = false;
      update();
    }
  }

  clickReportComment(int PEV_Code, int nowPage) async {
    if (this.isLoading) return;

    var url = 'http://$IP$PLANEVAL/report';
    var body = {
      'P_Evaluation_Plan_PL_Code': detail.code.toString(),
      'P_Evaluation_PEV_Code': PEV_Code.toString(),
      'page': nowPage.toString()
    };
    this.isLoading = true;
    var responseData = await HttpController.to.httpManeger("POST", url, body);

    if (responseData == 409) {
      this.isLoading = false;
      throw DuplicationException();
    } else {
      List<PlanEvaluation> evaluationList = parsingComment(responseData['evaluations']);
      commentCount = responseData['evaluationsCount'];
      lastPage = responseData['lastPage'];
      onlyCommentReplace(evaluationList);
      this.nowPage = nowPage;
      update();
      isLoading = false;
    }
  }

  // 게시글 신고 기능
  clickReport(int PL_Code) async {
    print(this.isLoading);
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;
    var responseData = await HttpController.to.httpManeger(
        "POST", 'http://$IP$PLANREPORT', {'PL_Code': PL_Code.toString()});
    // 블라인드된 게시물 체크
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    } else {
      isReport = responseData['isReport'];
      this.detail.reportCount = responseData['P_Report_Count'];
      update();
      this.isLoading = false;

    }
  }

  // 게시글 추천 기능
  clickHealthsee(int PL_Code) async {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;

    var responseData = await HttpController.to.httpManeger(
        "POST", 'http://$IP$PLANHEALTHSEE', {'PL_Code': PL_Code.toString()});
    if (responseData == 'blind') {
      this.isLoading = false;
      throw BlindPostException();
    } else {
      isHealthsee = responseData['isHealthsee'];
      this.detail.healthseeCount = responseData['P_Healthsee_Count'];
      update();
      this.isLoading = false;
    }
    print(this.isLoading);
  }

  // 게시글 새로 고침
  replaceWith(postDetail) {
    if (postDetail == null) return;
    this.detail = postDetail;
  }

  // 댓글만 새로고침
  onlyCommentReplace(List<PlanEvaluation> evaluations) {
    this.comments = [];
    this.comments.addAll(evaluations);
  }

  // 댓글 작성
  writeComment(String PEV_Content, int Plan_PL_Code, [int BC_Re_Ref]) async {
    isLoading = true;
    var page = (BC_Re_Ref == null) ? 1 : nowPage;
    var url = 'http://$IP$PLANEVAL';
    var body = {
      'PEV_Content': PEV_Content,
      'Plan_PL_Code': Plan_PL_Code.toString(),
      'page': page.toString()
    };
    print(Plan_PL_Code);
    var responseData = await HttpController.to.httpManeger("POST", url, body);
    List<PlanEvaluation> evaluationList = parsingComment(responseData['evaluations']);
    commentCount = responseData['evaluationsCount'];
    lastPage = responseData['lastPage'];
    nowPage = page;
    onlyCommentReplace(evaluationList);
    update();
    isLoading = false;
  }

  updateComments (String PEV_Content, PEV_Code) async {
    isLoading = true;
    var url = 'http://$IP$PLANEVAL/${this.detail.code.toString()}';
    var body = {
      'PEV_Content': PEV_Content,
      'page': nowPage.toString(),
      'PEV_Code': PEV_Code.toString()
    };

    var responseData = await HttpController.to.httpManeger("PATCH", url, body);

    List<PlanEvaluation> evaluationList = parsingComment(responseData['evaluations']);
    commentCount = responseData['evaluationsCount'];
    lastPage = responseData['lastPage'];
    onlyCommentReplace(evaluationList);
    update();
    isLoading = false;
  }

  // 댓글 삭제
  removeComment(int PL_Code, int code) async {
    isLoading = true;
    var url = 'http://$IP$PLANEVAL/${this.detail.code}&${code}&${nowPage}';
    var responseData = await HttpController.to.httpManeger("DELETE", url);
    this.comments.removeWhere((element) => element.code == code);
    List<PlanEvaluation> evaluationList = parsingComment(responseData['evaluations']);
    commentCount = responseData['evaluationsCount'];
    lastPage = responseData['lastPage'];
    onlyCommentReplace(evaluationList);
    update();
    isLoading = false;
  }

  // 댓글 파싱
  parsingComment(evaluations) {
    isLoading = true;
    List<PlanEvaluation> evaluationList = <PlanEvaluation>[];

    for (var eval in evaluations) {
      PlanEvaluation evaluation = PlanEvaluation(
          eval['PEV_Code'],
          eval['PEV_Writer_NickName'],
          eval['PEV_Content'],
          DateFormat("yyyy-MM-dd HH:mm").format(
              DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                  .parseUTC(eval['PEV_Creation_Date'])
                  .toLocal()),
          eval['Plan_PL_Code'],
        eval['PEV_State'],
          eval['PE_Report_Count']
          );
      evaluationList.add(evaluation);
    }
    return evaluationList;
  }


  getPageComment(int BO_Code, int page) async {
    isLoading = true;
    var url = 'http://$IP$PLANEVAL/$BO_Code&${page}';
    var responseData = await HttpController.to.httpManeger("GET", url);
    List<PlanEvaluation> evaluationList = parsingComment(responseData['evaluations']);
    commentCount = responseData['evaluationsCount'];
    lastPage = responseData['lastPage'];
    onlyCommentReplace(evaluationList);
    nowPage = page;
    update();
    isLoading = false;
  }

  selectTotalReps(context) async {
    bool isChanged = false;
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
          width: Get.width,
          height: Get.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("반복 횟수를 선택해주세요"),
              CupertinoPicker(
                onSelectedItemChanged: (int index){
                  totalReps=index;
                  isChanged=true;
                },
                itemExtent: 100.0,
                children: List.generate(100, (index) => Center(child: Text('$index'))),
              ),
              RaisedButton(
                child: Text("완료"),
                onPressed: () => Get.toNamed('/trainingWebview'),
              )
            ],
          ),
        ));
    if(!isChanged)
      totalReps=1;
  }

}