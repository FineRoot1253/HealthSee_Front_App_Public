import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_list_controller.dart';
import 'package:heathee/controller/plan/plan_main_controller.dart';
import 'package:heathee/model/plan/plan_list.dart';
import 'package:heathee/model/util/error.dart';

class PlanListItem extends StatelessWidget {
  var controller;
  final PlanList planList;

  PlanListItem({@required this.controller, @required this.planList});

  @override
  Widget build(BuildContext context) {
    return buildPostTile(this.planList);
  }

  buildPostTile(PlanList planList) {
    print("지금 스코프 ${planList.scope}");
    return Container(
      width: Get.width*0.9,
      height: Get.height*0.1,
      child: InkWell(
        onTap: ()async {
          try {
            await PlanDetailController.to.readPostDetail(planList.code);
          }on BlindPostException {
            Get.snackbar("블라인드 경고", '해당 글은 블라인드 처리된 게시글입니다.');
            return ;
          }
          Get.toNamed('/planDetail', arguments: PlanDetailController.to);
        },
        child: (planList.scope == 2) ? Center(child: Text("블라인드 처리된 게시글 입니다"),) :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Card(
                child: Image.asset(
                  'assets/image/exce.png',
                  width: 50, height: 50,)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("코스명 : ${planList.title}"),
                Text("세트 만든이 : ${planList.nickname}"),
                Text("운동 종류 : ${(routinNameSet(planList.routin).toString().length > 10) ? routinNameSet(planList.routin).toString().substring(0,10)+"..." : routinNameSet(planList.routin)}")
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${(controller.value=='최근 운동 목록')? '운동 날짜':'제작일'} : ${planList.createAt.split(" ")[0]}"),
                Text("추천 수 : ${planList.healthseeCount}"),
                Text("평가 수 : ${planList.evaluationCount}"),
              ],
            ),
          ],
        ),),
    );
  }

  routinNameSet(List<dynamic> routin){
    String result = '';
    for(int i =0 ; i<routin.length; i++){
      if(i%2==0)
        result += '${routin[i]} ';
    }
    return result;
  }
}
