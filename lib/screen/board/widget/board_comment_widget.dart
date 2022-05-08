import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/widget/comment/comment_bar.dart';
import 'package:heathee/widget/comment/comment_item.dart';
import 'package:heathee/widget/comment/comment_writer.dart';
import 'package:get/get.dart';
import 'package:heathee/keyword/color.dart';

class BoardCommentWidget extends StatelessWidget {
  PostDetailController postDetailController;
  String myUserName = AccountController.to.nickname;
  BoardCommentWidget(this.postDetailController);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CommentBar(postDetailController),
        Divider(
          height: 1.0,
          color: Colors.white60,
        ),
        GestureDetector(
          onTap: () => commentBottomSheet(),
          child: Container(
            height: 50,
            child: Center(
              child: Text(
                "댓글 추가하기 ...",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Divider(
          height: 1.0,
          color: Colors.white60,
        ),
        ConditionalBuilder(
          condition: (postDetailController.comments.length > 0),
          builder: (context) => CommentTiles(postDetailController, true),
          fallback: (context) => Container(),
        ),
      ],
    );
  }

  commentBottomSheet([int code, String content]) {
    return Get.bottomSheet(
      Wrap(children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: CommentWriter(postDetailController, code, content),
        ),
      ]),
      backgroundColor: BACKGROUND_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
    );
  }
}
