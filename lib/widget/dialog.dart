import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:path/path.dart';

yesOrNoDialog(String title, String middleText) {
  return Get.defaultDialog(actions: <Widget>[
    new FlatButton(
      child: new Text("예"),
      onPressed: () {
        Get.back(result: true);
      },
    ),
    new FlatButton(
      child: new Text("아니오"),
      onPressed: () {
        Get.back(result: false);
      },
    ),
  ], title: title, middleText: middleText);
}

uploadDialog() {
  return Get.defaultDialog(
      title: "업로드",
      content: GetBuilder<HttpController>(builder: (_) {
        if (HttpController.to.progress == null) {
          return Container(
            child: Text(""),
          );
        } else if (HttpController.to.progress == 1.0) {
          return Container(
            child: Text("업로드 완료"),
          );
        } else {
          //print("${HttpController.to.progress}");
          return Center(
              child: CircularProgressIndicator(
            value: HttpController.to.progress,
          ));
        }
      }));
}

profileImgDialog() {
  return Get.defaultDialog(
      title: "프로필 사진 변경",
      content: Column(
        children: <Widget>[
          FlatButton(
              onPressed: () async {
                await Get.toNamed('/myPageProfileMake');
                Get.back();
              },
              child: Text("갤러리/카메라에서 가져오기")),
          FlatButton(onPressed: () {}, child: Text("앨범에서 가져오기(미구현)")),
          ConditionalBuilder(
              condition: (MyPageController.to.myUser.picture != null),
              builder: (context) {
                return FlatButton(
                    onPressed: () {
                      MyPageController.to.myUser.tempProfileImage = null;
                      MyPageController.to.myUser.nowProfileImage = null;
                      MyPageController.to.isExist = false;
                      Get.back(result: false);
                    },
                    child: Text("프로필 사진 삭제"));
              })
        ],
      ));
}

downloadDialog(String url, String filename, {String directory}) {
  return Get.defaultDialog(
      title: "다운로드",
      content: GetBuilder<HttpController>(initState: (_) {
        HttpController.to.startDownloading(url, filename, directory: directory);
      }, builder: (_) {
        if (HttpController.to.progress == null)
          return Container(
            height: 10,
            width: 10,
          );
        else if (HttpController.to.progress == 1.0) {
          return Container();
        } else
          return Center(
              child: CircularProgressIndicator(
            value: HttpController.to.progress,
          ));
      }));
}
