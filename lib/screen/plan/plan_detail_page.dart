import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_list_controller.dart';
import 'package:heathee/controller/plan/plan_main_controller.dart';
import 'package:heathee/model/auth/member.dart';
import 'package:heathee/screen/board/widget/board_comment_widget.dart';
import 'package:heathee/screen/board/widget/board_detail_widget.dart';
import 'package:heathee/screen/plan/widget/plan_detail_widget.dart';
import 'package:heathee/screen/plan/widget/plan_evaluation_widget.dart';

class PlanDetailPage extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController comment = TextEditingController();
  PlanDetailController planDetailController;
  Member myUser;

  @override
  Widget build(BuildContext context) {
    planDetailController = Get.arguments;
    myUser = AccountController.to.myMember;
    return GetBuilder<PlanDetailController>(
      init: PlanDetailController(
          detail: planDetailController.detail,
          comments: planDetailController.comments,
          lastPage: planDetailController.lastPage,
          isHealthsee: planDetailController.isHealthsee,
          isReport: planDetailController.isReport,
          commentCount: planDetailController.commentCount,
          nowPage: planDetailController.nowPage,
          isLoading: planDetailController.isLoading),
      builder: (_) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(_.detail.title),
                leading: IconButton(icon: Icon(Icons.arrow_back), onPressed:
                    () async {
                      PlanListController.to.planList =[];
//                  await PlanListController.to.fetch(false);
                      PlanMainController.to.value = "내 운동 세트";
                      await PlanMainController.to.init();
                      (_.isCopied)? Get.until(ModalRoute.withName('/planMain')) : Get.back();
                      _.isCopied = false;
                      print(" isCopied? : ${_.isCopied}");
                }
                ),
              actions: <Widget>[
                (_.detail.writer_NickName == AccountController.to.nickname) ? buildDropBtn(_) : Container(),
                FlatButton(
                  child: Text('시작'),
                  onPressed: () => _.selectTotalReps(context),
                )]
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {},
              child: SafeArea(
                child: SingleChildScrollView(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: Get.width,
                    height: Get.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        PlanDetailWidget(_),
                        Divider(
                          height: 1.0,
                          color: Colors.white60,
                        ),
                        PlanEvaluationWidget(_)
                      ],
                    ),
                  ),
                )),
              ),
            ));
      },
    );
  }
  buildDropBtn(_){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        DropdownButton(
            value: _.value,
            items: _
                .valueList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) async =>
            await _.dropDownBtn(value))
      ],
    );
  }
}
