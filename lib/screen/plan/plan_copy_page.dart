import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/plan/plan_copy_controller.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/plan/plan_detail.dart';
import 'package:heathee/screen/plan/widget/exercise_tile_widget.dart';
import 'package:heathee/screen/training/widget/Training_menu_bar.dart';

class PlanCopyPage extends StatefulWidget {


  @override
  _TrainingStartPageState createState() => _TrainingStartPageState();
}

class _TrainingStartPageState extends State<PlanCopyPage> {

  PlanDetailController planDetailController;
  Plan plan;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    planDetailController = Get.arguments;
    plan = planDetailController.detail;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanCopyController>(
      initState: (_){ PlanCopyController.to.init(PL_Code: plan.code,routin: plan.routin, restTime: plan.restTIme); },
      init: PlanCopyController(),
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("코스 설정"),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                child: Text("완료"),
                onPressed: () {
                  List<String> routinList=[];
                  print(_.getExceRepsEditingControllers[0].text);
                  for(var i = 0 ; i < _.routin.length/2; i++){
                    if(_.getExceRepsEditingControllers[i].text.isEmpty){
                      Get.snackbar("알림", '빈칸을 기재하지 않으면 진행 할 수 없습니다.');
                      return ;
                    }
                    routinList.add(_.routin[i*2]);
                    routinList.add(_.getExceRepsEditingControllers[i].text);
                  }
                  planDetailController.isCopied = true;
                  planDetailController.writePostDetail(
                      title: planDetailController.detail.title,nickName: AccountController.to.nickname,description: planDetailController.detail.description,
                      routin: json.encode(routinList),restTime: _.restTime.inSeconds,scope: 1);
                  //TODO: 수정이 필요 read쪽에 추가해야함 ↓
//                  PlanMainController.to.isFromCopyPage = true;
//                  PlanMainController.to.update();
//                  Get.toNamed('/trainingWebview');
                  },
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TrainingMenuBar(_,"운동 횟수 선택"),
              buildExerList(_),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 1.0,
                  color: Colors.white,
                ),
              ),
              buildTrainingDetail(context,_),
            ],
          ),
        );
      },
    );
  }

  buildExerList(controller){
    return Container(
      height: Get.height*0.25,
      width: Get.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: (plan.routin.length/2).floor(),
          itemBuilder: (context, i) => ExerTileWidget(plan.routin, i,controller)
      ),
    );
  }

  buildTrainingDetail(context, controller) {
    return buildRestTimeTile(context,controller);
  }

  buildRestTimeTile(context,controller) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              color: CONTENT_COLOR,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '쉬는 시간',
                      style: MENUBAR_TEXT_STYLE,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 35,
                    child: IconButton(
                      icon: Icon(Icons.timer),
                      onPressed: (){
                        controller.selectTime(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
//        PlanMenuBar(controller, '쉬는 시간', '선택'),
        Text(format(controller.restTime)),
      ],
    );
  }

  buildTotalRepsTile(context,controller) {

    List<String> value = ["비공개","공개"];
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              color: CONTENT_COLOR,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '반복 횟수',
                      style: MENUBAR_TEXT_STYLE,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 35,
                    child: IconButton(
                      icon: Icon(Icons.list),
                      onPressed: () async => await controller.selectTotalReps(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text("${controller.totalReps} 회")
      ],
    );
  }
  format(Duration d) =>
      d
          .toString()
          .split('.')
          .first
          .padLeft(8, "0");
}
