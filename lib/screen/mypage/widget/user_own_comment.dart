import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/controller/mypage/mypage_own_comment_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/board/comment.dart';
import 'package:heathee/model/util/error.dart';

class UserOwnComment extends StatelessWidget {
  final String nickname;

  const UserOwnComment({Key key, this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPageOwnCommentController>(
        init: MyPageOwnCommentController(),
        initState: (_) {
          MyPageOwnCommentController.to.init(nickname);
        },
        builder: (_) {
          return UsersCommentList();
        });
  }
}

class UsersCommentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: MyPageOwnCommentController.to.userOwnList?.length ?? 0,
      controller: MyPageOwnCommentController.to.scrollController,
      separatorBuilder: (context, i) {
        if (i % 10 == 9)
          return Row(
            children: <Widget>[
              Text("${(i / 10 + 0.1).toInt()}Page "),
              Expanded(
                  child: Divider(
                height: 0.5,
              ))
            ],
          );
        else
          return Divider(
            height: 0.1,
          );
      },
      itemBuilder: (context, i) {
        return postListItem(
          context,
          MyPageOwnCommentController.to.userOwnList[i],
          // key: ValueKey('PostListItem' + randomString()),
        );
      },
    );
  }

  Widget postListItem(context, Comment comment) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: CONTENT_COLOR,
          child: ListTile(
              onTap: () async {
                try {
                  await PostDetailController.to
                      .readPostDetail(comment.boardCode);
                } on BlindPostException {
                  Get.snackbar("블라인드 게시글", "블라인드 처리된 게시글을 열람하실 수 없습니다.");
                }
              },
              key: Key(comment.code.toString()),
              subtitle: Text(comment.createAt, style: LIST_TEXT_STYLE),
              title: ConditionalBuilder(
                condition: comment.state == 0,
                builder: (context) {
                  return Text(
                    comment.content,
                    style: LIST_TITLE_STYLE,
                    overflow: TextOverflow.ellipsis,
                  );
                },
                fallback: (context) {
                  return ConditionalBuilder(
                    condition: comment.state == 1,
                    builder: (context) {
                      return Text(
                        "블라인드 처리된 댓글입니다.",
                        style: LIST_TITLE_STYLE,
                      );
                    },
                    fallback: (context) {
                      return Text(
                        "삭제된 댓글입니다.",
                        style: LIST_TITLE_STYLE,
                      );
                    },
                  );
                },
              )),
        ),
      ),
    );
  }
}
