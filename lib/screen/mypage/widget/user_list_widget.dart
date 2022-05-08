import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/mypage/user.dart';

/* 20/07/23 홍종표
* todo: 나중에 BlindError 말고도 차단 에러를 만들어야함.
 */
class MyPageListWidget extends StatelessWidget {
  MyPageListWidget({Key key, @required this.users, @required this.controller})
      : super(key: key);

  final List<User> users;
  final controller;
  MyPageController myPageController = Get.put(MyPageController());
  @override
  Widget build(BuildContext context) {
    /// 글을 목록한다.
    return ListView.separated(
      itemCount: users.length,
      controller: controller,
      separatorBuilder: (context, i) {
        return Divider(
          height: 0.1,
        );
      },
      itemBuilder: (context, i) {
        return listItem(
          context,
          users[i],
          // key: ValueKey('PostListItem' + randomString()),
        );
      },
    );
  }

  Widget listItem(context, User user) {
    return Card(
      color: CONTENT_COLOR,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListTile(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            if (user.scope == 0)
              Get.toNamed('myPageOthers', arguments: user.nickname);
            else
              Get.snackbar("비공개 유저", "비공개된 유저의 마이페이지를 열람하실 수 없습니다.");
          },
          dense: true,
          key: Key(user.code.toString()),
          leading: _buildProfileImage(user),
          title: Text(
            user.nickname,
            style: TITLE_TEXT_STYLE,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(User user) {
    return ConditionalBuilder(
      condition: user.picture != null,
      builder: (context) {
        return Image.memory(
          user.picture,
          fit: BoxFit.cover,
        );
      },
      fallback: (context) {
        return Image.asset(
          'assets/image/profile_image/blank_profile_picture.jpg',
          fit: BoxFit.cover,
        );
      },
    );
  }
}
