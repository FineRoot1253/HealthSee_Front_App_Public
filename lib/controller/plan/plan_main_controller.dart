import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_list_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/plan/plan_detail.dart';
import 'package:heathee/model/plan/plan_list.dart';
import 'package:http/http.dart';

class PlanMainController extends GetxController {
  List<PlanList> _planList =List<PlanList>();

  List<PlanList> get getPlanList => _planList;

  String value = "최근 운동 세트";
  String category = "UserLogList";
  List<String> valueList = ["최근 운동 세트", "인기 운동 세트", "내 운동 세트","최신 운동 세트"];
  List<String> categoryList = [
    "UserLogList",
    "bestPlanList",
    ''
  ];

  static PlanMainController get to => Get.put(PlanMainController());
  PlanListController planListController = Get.put(PlanListController());
  PlanDetailController planDetailController = Get.put(PlanDetailController());

  init() async {
    print('이닛');
    await dropDownBtn(this.value);
  }





  dropDownBtn(String value) async {
    String url = '';
    switch (value) {
      case '최근 운동 세트':
        category = categoryList[0];
        this.value = valueList[0];
        url = 'http://$IP$PLANLIST/$category/${AccountController.to.nickname}';
        break;
      case '인기 운동 세트':
        category = categoryList[1];
        this.value = valueList[1];
        url = 'http://$IP$PLANLIST/$category/';
        print('여기일건데$url');
        break;
      case '내 운동 세트':
        category = categoryList[2];
        this.value = valueList[2];
        url = 'http://$IP$PLANLIST/${category}PL_Writer_Nickname&${AccountController.to.nickname}';
        //TODO: &?PL_Code=1 로 쿼리 추가 가능 스크롤 컨트롤러에 추가할 것
        break;
      default :
        category = categoryList[2];
        this.value = valueList[3];
        url = 'http://$IP$PLANLIST/';
        break;
    }
    planListController.url = url;
    planListController.category=category;
    planListController.value=value;
    planListController.planList = [];
    await planListController.fetch(false);
    update();
  }


}
