import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_main_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/plan/plan_list.dart';

class PlanListController extends GetxController{

  final ScrollController scrollController = ScrollController();
  List<PlanList> planList=List<PlanList>();
  String url;
  bool isNotExist = true;
  bool loading = false;
  String value = "최근 운동 세트";
  String category = "UserLogList";
  int leaves;
  int endAt = -1;
  Future result;
  static PlanListController get to => Get.put(PlanListController());
  List<PlanList> get getList => planList;

  init() async {
    this.planList = [];
    await fetch(false);
    scrollController.addListener(_scrollListener);
  }

  fetch(bool isNext) async {

    String value;

    if (!isNext && this.value == '인기 운동 세트') {
      this.planList = [];
    } else if(isNext) {
      switch(this.value){
        case '최근 운동 세트':
          url = 'http://$IP$PLANLIST/$category/${AccountController.to.nickname}?PL_Code=${endAt}';
          break;
        case '내 운동 세트':
          url = 'http://$IP$PLANLIST/${category}PL_Writer_Nickname&${AccountController.to.nickname}?PL_Code=${endAt}';
          break;
        case '최신 운동 세트':
          url = 'http://$IP$PLANLIST/?PL_Code=${endAt}';
          break;
      }
    }
    print(url);

    var responseData = await HttpController.to.httpManeger("GET", url);
    if(category!='bestPlanList'&&category!='UserLogList')
      value = 'planList';
    else
      value = category;
    print(value);
    print(responseData[value]);
    leaves = responseData['planCount'];

    if (leaves == null)
      isNotExist = true;
    else if (leaves <= 10) {
      isNotExist = true;
    } else
      isNotExist = false;

    if(responseData[value]!=null) {
      for( var pl in responseData[value]){
        try {
          PlanList planlist = fetchList(pl);
          this.planList.add(planlist);
        }catch (e){
          print("아니 이유가 있으면 말을 해봐 ${e.toString()}");
        }
      }
      print(planList.length);
      endAt = this.planList[planList.length - 1].code;
    }

    print("다시 받아야할 코드 : $endAt");
    update();
    loading = false;

//    planListController.planList = List.from(_planList);
//    planListController.url = url;
    //TODO: 여기서 _planList set 해주기
  }

  fetchList(e) {
    PlanList list;
    switch (category) {
      case 'UserLogList' :
        list = PlanList(
            code: e["PL_Code"],
            nickname: e['PL_Writer_NickName'],
            title: e['PL_Title'],
            createAt: e['LO_Creation_Date'],
            routin: e['PL_Routin'],
            scope: e['PL_Scope'],
            evaluationCount: e['P_Evaluation_Count'],
            healthseeCount: e['P_Healthsee_Count'],
            reportCount: e['P_Report_Count']
        );
        return list;
        break;
      default :
        list = PlanList.fromJson(e);
        return list;
        break;
    }
  }

  void _scrollListener() {
    print("작동");
    if (isNotExist) return;
    if (loading) {
      return;
    }
    double isBottom = (scrollController.position.maxScrollExtent * 0.95);
    if (scrollController.offset > isBottom && value != '인기 운동 세트') {
      this.loading = true;
      if (!isNotExist) fetch(true);
    }
  }

  Future<Null> refreshPostLists() async {
    if (this.planList.isNotEmpty) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    }

    this.loading = true;
    this.planList = [];
    await PlanMainController.to.init();
//    await fetch(false);
  }
}