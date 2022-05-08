import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanCopyController extends GetxController{

  static PlanCopyController get to => Get.put(PlanCopyController());
  List<GlobalKey<FormState>> get getExerFormKeyList => _exerFormKeyList;
  List<TextEditingController> get getExceRepsEditingControllers => _exceRepsEditingControllers;

  Duration restTime = Duration(seconds: 60);
  int PL_Code;
  List<dynamic> routin;
  int totalReps=1;
  List<TextEditingController> _exceRepsEditingControllers = [TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()];
  final List<GlobalKey<FormState>> _exerFormKeyList = [GlobalKey<FormState>(),GlobalKey<FormState>(),GlobalKey<FormState>(),GlobalKey<FormState>(),GlobalKey<FormState>()];


  init({int PL_Code, List<dynamic> routin, int restTime}){
    this.restTime = Duration(seconds: restTime) ?? Duration(seconds: 60);
    this.PL_Code = PL_Code;
    this.routin = routin;
    for(int i = 0; i < this.routin.length ; i++){
      if(i%2==1)
        _exceRepsEditingControllers[(i/2).floor()].text = routin[i].toString();
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



}