import 'dart:ui';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/mypage/user.dart';

class MyPageMainPage extends StatefulWidget {
  MyPageMainPage(this.nickname);

  String nickname;
  @override
  _MyPageMainPageState createState() => _MyPageMainPageState();
}

class _MyPageMainPageState extends State<MyPageMainPage> {
  MyPageController myPageController = Get.put(MyPageController());
  Future<User> user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = MyPageController.to.readMyPage(widget.nickname);
  }

  @override
  Widget build(BuildContext context) {
    if (MyPageController.to.myUserIsChanged)
      user = MyPageController.to.readMyPage(widget.nickname);
    return GetBuilder(
        init: MyPageController(),
        builder: (_) {
          return FutureBuilder(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                }
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: CONTENT_COLOR,
                    title: Text("나의 마이페이지"),
                  ),
                  backgroundColor: BACKGROUND_COLOR,
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildProfileImage(snapshot.data),
                          SizedBox(
                            height: 10,
                          ),
                          _getProfileHeader(snapshot.data),
                          Divider(
                            height: 30.0,
                            thickness: 1.0,
                            color: Colors.black,
                          ),
                          _editProfileBtn(snapshot.data),
                          SizedBox(
                            height: 10,
                          ),
                          buildDetail(),
                          FlatButton(
                              onPressed: () {
                                Get.toNamed('/exercise', arguments: "squat");
                              },
                              child: Container(
                                color: Colors.blue,
                                child: Text("스쿼트 운동으로~"),
                              )),
                          FlatButton(
                              onPressed: () async {
                                Get.toNamed('/exerciseList');
                              },
                              child: Container(
                                color: Colors.blue,
                                child: Text("운동 추가 테스트 "),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Row buildDetail() {
    return Row(
      children: <Widget>[
        Container(
          width: Get.width / 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "성별 : ${(MyPageController.to.myUser.gender == 0) ? "남성" : "여성"}",
              style: STATUS_TEXT_STYLE,
            ),
            Text(
              "생년월일 : ${MyPageController.to.myUser.birth}",
              style: STATUS_TEXT_STYLE,
            ),
            Text(
              "체중 : ${MyPageController.to.myUser.weight} kg",
              style: STATUS_TEXT_STYLE,
            ),
            Text(
              "신장 : ${MyPageController.to.myUser.height} cm",
              style: STATUS_TEXT_STYLE,
            ),
          ],
        ),
      ],
    );
  }

  buildProfileImage(snapshot) {
    return Column(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ConditionalBuilder(
              condition: (snapshot.picture != null),
              builder: (context) {
                return Container(
                  width: 175,
                  height: 175,
                  child: Image.memory(
                    snapshot.picture,
                    fit: BoxFit.cover,
                  ),
                );
              },
              fallback: (context) {
                return Container(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    'assets/image/profile_image/blank_profile_picture.jpg',
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          MyPageController.to.myUser.nickname,
          style: NAME_TEXT_STYLE,
        )
      ],
    );
  }

  Row _getProfileHeader(snapshot) => Row(
        children: <Widget>[
          Expanded(
            child: Table(children: [
              TableRow(children: [
                _getStatus("게시글", snapshot.boardCount, () async {
                  await Get.toNamed('/myPageOwnBoard',
                      arguments: widget.nickname);
                }),
                _getStatus("앨범", snapshot.albumCount, () async {
                  await Get.toNamed('/myAlbum');
                  user = MyPageController.to.readMyPage(widget.nickname);
                }),
                _getStatus("출석", 123, () {}),
              ]),
            ]),
          ),
        ],
      );

  Widget _getStatus(String title, int value, Function onPressed) {
    return FlatButton(
      onPressed: onPressed,
      child: Column(
        children: <Widget>[
          _getStatusValueWidget(value.toString()),
          _getStatusLabelWidget(title),
        ],
      ),
    );
  }

  Widget _getStatusValueWidget(String value) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: STATUS_TEXT_STYLE,
            ),
          ),
        ),
      );

  Widget _getStatusLabelWidget(String value) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: STATUS_TEXT_STYLE,
            ),
          ),
        ),
      );

  Padding _editProfileBtn(snapshot) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: Get.width,
        height: 24,
        child: OutlineButton(
          onPressed: () async {
            await Get.toNamed('/myPageEdit', arguments: null);
            user = MyPageController.to.readMyPage(snapshot.nickname);
            setState(() {});
          },
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Text(
            '프로필 수정',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
