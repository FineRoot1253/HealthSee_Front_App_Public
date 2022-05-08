import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/plan/plan_write_controller.dart';

class PlanExceWidget extends StatefulWidget {
  final int index;
  final Key key;
  final PlanWriteController controller;

  PlanExceWidget(this.controller, this.index, this.key);

  @override
  _PlanExceWidgetState createState() => _PlanExceWidgetState();
}

class _PlanExceWidgetState extends State<PlanExceWidget> {
  @override
  Widget build(BuildContext context) {
    print('운동 위젯 현 상황 : ${widget.index}');
    return Container(
      height: Get.height*0.28,
      width: Get.width*0.3,
      child: Stack(
        children:<Widget>[
          InkWell(
            child: Card(
            child: Column(
              children: <Widget>[
                Card(
                  child: Image.asset(
                    'assets/image/${widget.controller.selectedExces[widget.index]}.jpg',
                    height: Get.height*0.18,
                    width: Get.width*0.18,
                  ),
                ),
                Text("운동명 : ${widget.controller.frontExcesStr[widget.index]}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("횟수 : "),
                    Container(
                      height: Get.height*0.02,
                      width: 50,
                      child: TextFormField(
                        key: widget.controller.getExerFormKeyList[widget.index],
                        validator: (value) {
                          if(value.isEmpty) return '횟수를 적어주세요';
                          return null;
                        },
                        controller: widget.controller.exceRepsEditingControllers[widget.index],
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
        ),
          ),
          printCancel()
        ] ,
      ),
    );
  }

  printCancel() {
    return Positioned(
        left: Get.width*0.21,
        bottom: Get.height*0.215,
        child: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () =>widget.controller.pressCancel(widget.index)));
  }

}
