import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/model/plan/plan_detail.dart';
import 'package:heathee/model/plan/plan_evaluation.dart';

class PlanWriteController extends GetxController {

  Plan detail;
  Duration restTime = Duration(seconds: 60);
  List<String> selectedExces = [];
  List<String> frontExcesStr=[];
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<GlobalKey<FormState>> _exerFormKeyList = [GlobalKey<FormState>(),GlobalKey<FormState>(),GlobalKey<FormState>(),GlobalKey<FormState>(),GlobalKey<FormState>()];
  final TextEditingController contentEditingController = TextEditingController();
  final TextEditingController titleEditingController = TextEditingController();
  List<TextEditingController> exceRepsEditingControllers = [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()];
  int scope=1;
  bool isOpen = true;


  static PlanWriteController get to => Get.put(PlanWriteController());
  List<GlobalKey<FormState>> get getExerFormKeyList => _exerFormKeyList;

  init({String content, String title, List<dynamic> routin, int scope, int restTime}){
    selectedExces = [];
    frontExcesStr=[];
    contentEditingController.text=content;
    titleEditingController.text=title;
    print(routin);
    print("이닛 스코프 상태 : ${scope}");
    this.scope=scope;

    if(scope==1)
      isOpen = true;
    else
      isOpen = false;

    this.restTime = Duration(seconds: restTime);

    for(int i = 0; i < routin.length/2; i++){
      String frontStr = (routin[i*2]=='squat') ? '스쿼트' : '푸시업';
      selectedExces.add(routin[i*2]);
      print('운동명 : ${routin[i*2]}, reps : ${routin[(i*2)+1]}');
      frontExcesStr.add(frontStr);
      exceRepsEditingControllers[i].text=routin[(i*2)+1];
    }

  }

  selectTime(context) async {
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
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.ms,
                initialTimerDuration: Duration(seconds: 60),
                onTimerDurationChanged: (_) async {
                  print(_.inMilliseconds);
                  restTime=_;
                  isChanged=true;
                },
              ),
              RaisedButton(
                child: Text("완료"),
                onPressed: () => Get.back(),
              )
            ],
          ),
        ));
    if(!isChanged)
      restTime=Duration(seconds: 60);
    update();
  }

  void onReorder(int oldIndex, int newIndex) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final String item1 = selectedExces.removeAt(oldIndex);
        final String item2 = frontExcesStr.removeAt(oldIndex);
        final TextEditingController item3 = exceRepsEditingControllers.removeAt(oldIndex);
        selectedExces.insert(newIndex, item1);
        frontExcesStr.insert(newIndex, item2);
        exceRepsEditingControllers.insert(newIndex, item3);
        update();
  }

  pressCancel(index){
    print("$index 삭제 및 초기화");
    selectedExces.removeAt(index);
    frontExcesStr.removeAt(index);
    exceRepsEditingControllers[index].text = "";
    update();
  }

}