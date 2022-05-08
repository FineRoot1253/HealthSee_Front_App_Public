import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/plan/plan_list_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/plan/plan_list.dart';
import 'package:http/http.dart';

class PlanSearchController extends GetxController{

  final ScrollController scrollController = ScrollController();

  final bool isSearched = false;
  List<PlanList> planList= [];
  bool isNotExist = false;
  bool loading = false;
  int leaves;
  int endAt = -1;
  String nameValue = '제목';
  String searchCategory = "PL_Title";
  String value = "검색 운동 세트";
  String url;
  String keyword;
  List<String> names = ['제목', '작성자'];
  List<String> categories = ['PL_Title', 'PL_Writer_NickName'];

  static PlanSearchController get to => Get.put(PlanSearchController());


  init() async {
    await fetch(false);
    scrollController.addListener(_scrollListener);
  }

  reset(){
    this.keyword = null;
    this.planList = [];
  }
  fetch(bool isNext) async {
  print(this.keyword);
    url = 'http://$IP$PLANLIST/${PlanSearchController.to.searchCategory}&$keyword';
    if (!isNext)
      this.planList = [];
    else
      url ='http://$IP$PLANLIST/${PlanSearchController.to.searchCategory}&$keyword?PL_Code=${endAt}';

    print(url);
    var responseData = await HttpController.to.httpManeger("GET", url);

    print(responseData['planList']);
    leaves = responseData['planCount'];
    print(leaves);

    if (leaves == null)
      isNotExist = true;
    else if (leaves <= 10) {
      isNotExist = true;
    } else
      isNotExist = false;

    print("다음페이지 존재여부 : $isNotExist");
    if(responseData['planList']!= null && responseData['planList'].isNotEmpty) {
      for( var pl in responseData['planList']){
        try {
          PlanList planlist = PlanList.fromJson(pl);
          this.planList.add(planlist);
        }catch (e){
          print("아니 이유가 있으면 말을 해봐 ${e.toString()}");
        }
      }
      print('총 받은 길이 : ${planList.length}');
      endAt = this.planList[planList.length - 1].code;
    }

    loading = false;
    update();
//    planListController.planList = List.from(_planList);
//    planListController.url = url;
    //TODO: 여기서 _planList set 해주기
  }



  void _scrollListener() {
    if (isNotExist) return;
    if (loading) {
      return;
    }
    double isBottom = (scrollController.position.maxScrollExtent * 0.95);
    if (scrollController.offset > isBottom) {
      this.loading = true;
      print("1");
      if (!isNotExist) {
        fetch(true);
      }
      }
  }

}