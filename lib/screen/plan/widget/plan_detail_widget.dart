import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/screen/plan/widget/plan_menu_bar.dart';

class PlanDetailWidget extends StatelessWidget {
  PlanDetailController controller;

  PlanDetailWidget(this.controller);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPicture(),
          Divider(
            height: 1.0,
            color: Colors.white60,
          ),
          PlanMenuBar(controller, '운동 설명', '찜하기'),
          buildDescrption(),
        ],
      ),
    );
  }

  buildPicture() {
    return SizedBox(
        width: Get.width,
        height: Get.height * 0.2,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Card(
                child: Image.asset(
              'assets/image/${controller.detail.routin[i * 2]}.jpg',
              width: 150,
              height: 150,
            ));
          },
          itemCount: (controller.detail.routin.length / 2).floor(),
        ));
  }

  buildDescrption() {
    return Container(
      height: Get.height * 0.2,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 7,
              child: SingleChildScrollView(
                  child: Text(controller.detail.description))),
          //TODO 헬시 빼는거 문제 해결하기 백엔드 손볼 필요 있음
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async { await controller.clickHealthsee(controller.detail.code);},
                      icon: (controller.isHealthsee)
                          ? Icon(Icons.favorite,color: Colors.pink,)
                          : Icon(Icons.favorite_border),
                    ),
                    IconButton(
                      icon: (controller.isReport)
                          ? Icon(Icons.flag, color: Colors.amberAccent,)
                          : Icon(Icons.outlined_flag),
                      onPressed: () async {
                        try {
                          await controller.clickReport(controller.detail.code);
                        } on BlindPostException {
                          print('블라 받음1');
                          print('블라 받음2');
                          Get.back();
                          Get.back();
                          Get.snackbar("블라인드 게시글", "블라인드 처리된 게시글을 열람하실 수 없습니다.");
                          print('블라 3');
                        }
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(controller.detail.healthseeCount.toString()),
                    Text(controller.detail.reportCount.toString())
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Divider(
                    height: 1.0,
                    color: Colors.white60,
                  ),
                ),
                Text("쉬는 시간"),
                Text("${format(Duration(seconds: controller.detail.restTIme))}")
              ],
            ),
          ),
        ],
      ),
    );
  }
  format(Duration d) =>
      d
          .toString()
          .split('.')
          .first
          .padLeft(8, "0");
}
