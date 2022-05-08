import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_write_controller.dart';
import 'package:heathee/screen/plan/widget/plan_write_widget.dart';

class PlanEditPage extends StatelessWidget {

  PlanDetailController detailController;
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: GetBuilder<PlanWriteController>(
          init: PlanWriteController(),
          initState: (_){
              detailController = Get.arguments;
            PlanWriteController.to.init(
              title: detailController.detail.title,
              content: detailController.detail.description,
              routin: detailController.detail.routin,
              restTime: detailController.detail.restTIme,
              scope: detailController.detail.scope
            );
          },
          builder: (_){
            return Scaffold(
              appBar: AppBar(
                title: Text('코스 편집'),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('완료'),
                    onPressed: () async {
                      List<String> routinList=[];
                      print("업로드 전 길이 확인 : ${_.selectedExces.length}");
                      for(var i = 0 ; i < _.selectedExces.length; i++){
                        routinList.add(_.selectedExces[i]);
                        routinList.add(_.exceRepsEditingControllers[i].text);
                      }
                      await PlanDetailController.to.updatePost(title: _.titleEditingController.text,
                          description: _.contentEditingController.text,
                          restTime: _.restTime.inSeconds,
                          scope: _.scope,
                          routin: json.encode(routinList));
                    },
                  )
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Text('운동 선택'),
                    ),
                    ListTile(
                      title: Text('스쿼트'),
                      onTap: (){
                        _.selectedExces.add('squat');
                        _.frontExcesStr.add('스쿼트');
                        _.update();
                        Get.snackbar('알림', '스쿼트를 추가하였습니다');
                        Get.back();
                      },
                    ),
                    ListTile(
                      title: Text('푸시업'),
                      onTap: (){
                        _.selectedExces.add('pushup');
                        _.frontExcesStr.add('푸시업');
                        _.update();
                        Get.snackbar('알림', '푸시업를 추가하였습니다');
                        Get.back();
                      },
                    )
                  ],
                ),
              ),
              body: SafeArea(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: PlanWriteWidget(_),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  find(){
    List<int> list = [2,3,5,7];
    int temp;

    for(var index in list){
      if(temp==3)
        temp=index;
    };
    return temp;
  }



}
//RaisedButton(
//child: Text("글작성"),
//onPressed: () => controller.planDetailController.writePostDetail(
//title: "testest",
//nickName: AccountController.to.nickname,
//description: "testestest",
//routin: json.encode(['squat', '10', 'pushup', '10']),
//restTime: 20,
//scope: 1),
//),
//RaisedButton(
//child: Text("댓글작성"),
//onPressed: () => controller.planDetailController.writeComment(
//"test", controller.planDetailController.detail.code),
//),
//RaisedButton(
//child: Text("댓글삭제"),
//onPressed: () => controller.planDetailController.removeComment(
//controller.planDetailController.comments[0].code),
//),
//RaisedButton(
//child: Text("글삭제"),
//onPressed: () => controller.planDetailController
//    .deletePost(controller.planDetailController.detail.code),
//),
//RaisedButton(
//child: Text("댓글신고"),
//onPressed: () => controller.planDetailController
//    .clickReportComment(controller.planDetailController.comments[0].code,1),
//),
//RaisedButton(
//child: Text("글신고"),
//onPressed: () => controller.planDetailController
//    .clickReport(controller.planDetailController.detail.code),
//),
//RaisedButton(
//child: Text("글추천"),
//onPressed: () => controller.planDetailController.clickHealthsee(controller.planDetailController.detail.code),
//),
//RaisedButton(
//child: Text("글 수정"),
//onPressed: () => controller.planDetailController.updatePost(
//title: "수정 테스트",
//description: "수정수정",
//routin: json.encode(['squat', '10', 'squat', '10']),
//restTime: 10,
//scope: 1),
//),
//RaisedButton(
//child: Text("댓글 수정"),
//onPressed: () => controller.planDetailController.updateComment("ㅅㅅㅅㅅㅅ",controller.planDetailController.comments[0].code),
//),