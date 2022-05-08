import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:heathee/keyword/color.dart';

class MypageProfileSendPage extends StatelessWidget {
  File image = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CONTENT_COLOR,
        title: Text("고른 사진"),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                final resizedFile = await FlutterNativeImage.compressImage(
                    image.path,
                    quality: 100,
                    targetHeight: 250,
                    targetWidth: 250);
                MyPageController.to.myUser.tempProfileImage = resizedFile;
                Get.back();
              },
              child: Text("확인"))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.file(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
