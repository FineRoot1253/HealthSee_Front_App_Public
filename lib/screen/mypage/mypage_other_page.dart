import 'dart:ui';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';

class MyPageOtherPage extends StatefulWidget {
  @override
  _MyPageOtherPageState createState() => _MyPageOtherPageState();
}

class _MyPageOtherPageState extends State<MyPageOtherPage> {
  MyPageController myPageController = Get.put(MyPageController());
  String user;
  Future<void> otherUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Get.arguments;
    otherUser = myPageController.readOtherUserMyPage(user);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MyPageController(),
        builder: (_) {
          return FutureBuilder(
              future: otherUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: CONTENT_COLOR,
                      title: Text(
                          myPageController.otherUser.nickname + "님의 마이페이지"),
                    ),
                    backgroundColor: BACKGROUND_COLOR,
                    body: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildProfileImage(myPageController.otherUser),
                            SizedBox(
                              height: 10,
                            ),
                            _getProfileHeader(myPageController.otherUser),
                            Divider(
                              height: 30.0,
                              thickness: 1.0,
                              color: Colors.black,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: Get.width / 8,
                                ),
                                ConditionalBuilder(
                                  condition:
                                      myPageController.otherUser.scope == 0,
                                  builder: (context) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "성별 : ${(myPageController.otherUser.gender == 0) ? "남성" : "여성"}",
                                          style: STATUS_TEXT_STYLE,
                                        ),
                                        Text(
                                          "생년월일 : ${myPageController.otherUser.birth}",
                                          style: STATUS_TEXT_STYLE,
                                        ),
                                        Text(
                                          "체중 : ${myPageController.otherUser.weight} kg",
                                          style: STATUS_TEXT_STYLE,
                                        ),
                                        Text(
                                          "신장 : ${myPageController.otherUser.height} cm",
                                          style: STATUS_TEXT_STYLE,
                                        ),
                                      ],
                                    );
                                  },
                                  fallback: (context) {
                                    return Center(
                                      child: Text("비공개 유저입니다."),
                                    );
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
        });
  }

//
  buildProfileImage(user) {
    return Column(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ConditionalBuilder(
              condition: (user.picture != null),
              builder: (context) {
                return Container(
                  width: 250,
                  height: 250,
                  child: Image.memory(
                    user.picture,
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
          user.nickname,
          style: NAME_TEXT_STYLE,
        )
      ],
    );
  }

  Row _getProfileHeader(user) => Row(
        children: <Widget>[
          Expanded(
            child: Table(children: [
              TableRow(children: [
                _getStatus("게시글", user.boardCount, () {
                  return Get.toNamed('/myPageOwnBoard',
                      arguments: user.nickname);
                }),
                _getStatus("앨범", user.albumCount, () {
                  return Get.toNamed('/othersAlbum', arguments: user.nickname);
                }),
                _getStatus("출석", 123, () {}),
              ]),
            ]),
          ),
        ],
      );

  Widget _getStatus(String title, int value, Function onPressed) {
    return FlatButton(
      child: Column(
        children: <Widget>[
          _getStatusValueWidget(value.toString()),
          _getStatusLabelWidget(title),
        ],
      ),
      onPressed: onPressed,
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
}
