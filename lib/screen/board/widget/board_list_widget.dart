import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/board/post_list.dart';
import 'package:heathee/model/util/error.dart';

class PostListWidget extends StatelessWidget {
  PostListWidget({Key key, @required this.posts, @required this.controller})
      : super(key: key);

  final List<PostL> posts;
  final controller;
  PostDetailController postDetailController = Get.put(PostDetailController());
  @override
  Widget build(BuildContext context) {
    /// 글을 목록한다.
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: posts.length,
      controller: controller,
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
          posts[i],
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
          child: ListTile(
            onTap: () async {
              try {
                await PostDetailController.to.readPostDetail(post.code);
              } on BlindPostException {
                Get.snackbar("블라인드 게시글", "블라인드 처리된 게시글을 열람하실 수 없습니다.");
              }
            },
            key: Key(post.code.toString()),
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
            subtitle: Row(children: <Widget>[
              Text(post.nickname, style: LIST_TEXT_STYLE),
              Expanded(
                child: Text(
                  "      조회 ${post.hit}  추천 ${post.healthseeCount} ",
                  style: LIST_TEXT_STYLE,
                ),
              ),
              Text(post.createAt, style: LIST_TEXT_STYLE),
            ]),
          ),
        ),
      ),
    );
  }
}
