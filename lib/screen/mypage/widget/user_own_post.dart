import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/controller/mypage/mypage_own_post_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/board/post_list.dart';
import 'package:heathee/model/util/error.dart';

class UserOwnPost extends StatelessWidget {
  final String nickname;

  const UserOwnPost({Key key, this.nickname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPageOwnPostController>(
        init: MyPageOwnPostController(),
        initState: (_) {
          MyPageOwnPostController.to.init(nickname);
        },
        builder: (_) {
          return UsersPostListWidget();
        });
  }
}

class UsersPostListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: MyPageOwnPostController.to.userOwnList?.length ?? 0,
      controller: MyPageOwnPostController.to.scrollController,
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
          MyPageOwnPostController.to.userOwnList[i],
          // key: ValueKey('PostListItem' + randomString()),
        );
      },
    );
  }

  Widget postListItem(context, PostL post) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: CONTENT_COLOR,
          child: ListTile(
            onTap: () async {
              try {
                await PostDetailController.to.readPostDetail(post.code);
              } on BlindPostException {
                Get.snackbar("블라인드 게시글", "블라인드 처리된 게시글을 열람하실 수 없습니다.");
              }
            },
            key: Key(post.code.toString()),
            subtitle: Text(post.createAt, style: LIST_TEXT_STYLE),
            title: RichText(
                text: TextSpan(
                    text: (post.state == 0)
                        ? "${post.title} "
                        : "블라인드 처리된 게시글입니다.",
                    style: LIST_TITLE_STYLE,
                    children: <TextSpan>[
                  (post.commentCount > 0)
                      ? TextSpan(
                          text: " [${post.commentCount}]",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))
                      : TextSpan(text: "")
                ])),
          ),
        ),
      ),
    );
  }
}
