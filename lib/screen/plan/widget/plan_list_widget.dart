import 'package:flutter/material.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_list_controller.dart';
import 'package:heathee/controller/plan/plan_main_controller.dart';
import 'package:heathee/model/plan/plan_list.dart';
import 'package:heathee/screen/plan/widget/plan_list_item.dart';

class PlanListWidget extends StatelessWidget {

  final List<PlanList> planList;
  var controller;


  PlanListWidget({Key key, @required this.planList, @required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return buildBodyUserList();
  }
  buildBodyUserList(){
    print('출력');
    return (this.planList.isNotEmpty)?
     ListView.separated(
       physics: AlwaysScrollableScrollPhysics(),
       shrinkWrap: true,
       controller: this.controller.scrollController,
        itemBuilder: (context, i ) => PlanListItem(controller: this.controller, planList: this.planList[i],) ,
        separatorBuilder: (context, i) {
          return Divider(height: 1.0,);
        },
        itemCount: this.planList.length) :
    Center(child: Text("비어있습니다"),);
  }



}
