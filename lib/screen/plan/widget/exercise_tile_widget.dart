import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/plan/plan_copy_controller.dart';

class ExerTileWidget extends StatelessWidget {
  List<dynamic> routin;
  int index;
  PlanCopyController controller;

  ExerTileWidget(this.routin, this.index, this.controller);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/image/${routin[index * 2]}.jpg',
              height: Get.height*0.18,
              width: Get.width*0.18,
            ),
            Text('운동명 : ${routin[index * 2]}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("횟수 : "),
                Container(
                  height: Get.height*0.02,
                  width: 50,
                  child: TextFormField(
                    key: controller.getExerFormKeyList[index],
                    validator: (value) {
                      if(value.isEmpty) return '횟수를 적어주세요';
                      return null;
                    },
                    controller: controller.getExceRepsEditingControllers[index],
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
