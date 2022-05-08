import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/screen/board/widget/board_file.dart';
import 'package:heathee/widget/dialog.dart';

class BoardDetailWidget extends StatelessWidget {
  var controller;
  String myUserName = AccountController.to.nickname;
  BoardDetailWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildBoardTitle(),
        buildSpace(),
        BoardFilePart(file: controller.fileList),
        buildSpace(),
        buildBody(),
        buildSpace(),
        buildButton(),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
//BoardFilePart( file:_.detail.file),

  Widget buildBoardTitle() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  controller.detail.title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                controller.detail.nickname,
                style: TextStyle(color: Colors.white70),
              )),
              Text(controller.detail.createAt,
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    "조회 ${controller.detail.hit} 댓글 ${controller.commentCount}",
                    style: TextStyle(color: Colors.white)),
              ),
//              (Get.find<PostDetail>().BO_Writer_NickName == myUser.nickname)
              (controller.detail.nickname == myUserName)
                  ? Row(
                      children: <Widget>[
                        feedBack("  수정  "),
                        feedBack("  삭제  ", controller.detail.code),
                      ],
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Text(controller.detail.content,
              style: TextStyle(color: Colors.white70)),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Column buildButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                color: Colors.white,
                iconSize: 80,
                icon: (controller.isHealthsee)
                    ? Icon(Icons.sentiment_very_satisfied)
                    : Icon(Icons.sentiment_satisfied),
                onPressed: () {
                  controller.clickHealthsee(controller.detail.code);
                }),
            IconButton(
                color: Colors.white,
                iconSize: 80,
                icon: (controller.isReport)
                    ? Icon(Icons.sentiment_very_dissatisfied)
                    : Icon(Icons.sentiment_dissatisfied),
                onPressed: () async {
                  try {
                    await controller.clickReport(controller.detail.code);
                  } on BlindPostException {
                    Get.snackbar("블라인드 게시글", "블라인드 처리된 게시글을 열람하실 수 없습니다.");
                    Get.back();
                  }
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "추천 ${controller.detail.healthseeCount}",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              "신고 ${controller.detail.reportCount}",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        )
      ],
    );
  }

  Column buildSpace() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 1.0,
          color: Colors.white60,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  feedBack(String text, [int i]) {
    return GestureDetector(
        onTap: () async {
          switch (text) {
            case "  수정  ":
              Get.offNamed("/boardUpdate", arguments: controller);
              break;
            case "  삭제  ":
              bool result = await yesOrNoDialog("게시글 삭제", "게시글을 삭제하시겠습니까?");
              if (result) {
                await controller.deletePost(controller.detail.code);
              }
              break;
            default:
              break;
          }
        },
        child: Container(
            child: Text(
          text,
          style: LITTLE_TEXT_STYLE,
        )));
  }
}
