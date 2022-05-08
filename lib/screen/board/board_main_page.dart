import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/controller/board/board_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/board/post_list.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/widget/bar/button_bar.dart';

class BoardMainPage extends StatelessWidget {
  PostDetailController postDetailController = Get.put(PostDetailController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoardMainController>(
        init: BoardMainController(),
        initState: (_) {
          Get.find<BoardMainController>().getBest();
        },
        builder: (_) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('게시판'),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      DropdownButton(
                          value: Get.find<BoardMainController>().value,
                          items: Get.find<BoardMainController>()
                              .valueList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) async =>
                              await Get.find<BoardMainController>()
                                  .onChanged(value))
                    ],
                  ),
                ],
              ),
              body: buildBody(),
            ));
  }

  Column buildBody() {
    return Column(
      children: <Widget>[
        MenuBar("자유게시판", "더 보기"),
        Expanded(
          flex: 1,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: Get.find<BoardMainController>().best3Free.length,
            separatorBuilder: (context, i) {
              return Divider(
                height: 0.1,
              );
            },
            itemBuilder: (context, i) {
              return postListItem(
                context,
                Get.find<BoardMainController>().best3Free[i],
                // key: ValueKey('PostListItem' + randomString()),
              );
            },
          ),
        ),
      ],
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
                PostDetailController postDetail =
                    await PostDetailController.to.readPostDetail(post.code);

//                Get.toNamed("/boardDetail", arguments: postDetail);
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
