import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/api/timeset.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/controller/plan/plan_main_controller.dart';
import 'package:heathee/controller/plan/plan_write_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/keyword/key.dart';

class TrainingMenuBar extends StatelessWidget {

  var controller;
  final String title;
  final String content;

  TrainingMenuBar(this.controller, this.title, [this.content]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ClipPath(
              clipper: TrapeziumClipper(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                color: CONTENT_COLOR,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: MENUBAR_TEXT_STYLE,
                      ),
                    ),
                    (this.content != null) ? SizedBox(
                        height: 30,
                        child: FlatButton(
                          child: Text(
                            content,
                            style: MENUBAR_TEXT_STYLE,
                          ),
                          onPressed: callback(context),
                        ),
                      ) : Container(height: 30,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  callback(context) {
    if (title.startsWith("쉬는")) {
      return () async {
        await PlanWriteController.to.selectTime(context);
      };
    }
    if (title.startsWith("운동")) {
      print("여기");
      return () => PlanWriteController.to.scaffoldKey.currentState.openDrawer();
    }
    if (title.startsWith("인기")) {
      return () async {
        await Get.toNamed("/planBestList", arguments: controller);
      };
    }
  }
}

monthTap(controller) {
  Get.toNamed("/albumWrite", arguments: controller);
  print('asfasfasfasfasfasfasfasfasf');
//  AlbumMainController.to.albumListController.listResult = AlbumMainController.to.albumListController.init(AlbumMainController.to.albumListController.currentNickname);
  AlbumMainController.to.update();
}

class TrapeziumClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 2 / 3, 0.0);
    path.lineTo(0.0, size.height * 3.5);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width * 2 / 3 + 20, 0.0);
    path.lineTo(0.0, size.height * 3.5 + 20);
    path.lineTo(0.0, size.height * 3.5 + 40);
    path.lineTo(size.width * 2 / 3 + 40, 0.0);
    path.lineTo(size.width * 2 / 3 + 60, 0.0);
    path.lineTo(0.0, size.height * 3.5 + 60);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width * 2 / 3 + 60, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapeziumClipper oldClipper) => false;
}
