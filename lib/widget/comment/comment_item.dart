import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/album/album_detail_controller.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/controller/plan/plan_detail_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/album/a_comment.dart';
import 'package:heathee/model/board/comment.dart';
import 'package:heathee/model/plan/plan_evaluation.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/screen/board/board_detail_page.dart';
import 'package:heathee/widget/comment/comment_writer.dart';
import 'package:heathee/widget/dialog.dart';

class CommentTiles extends StatelessWidget {
  var controller;
  bool isBoard;
  String myUserName = AccountController.to.nickname;
  String str;
  CommentTiles(this.controller, this.isBoard);

  @override
  Widget build(BuildContext context) {
    str = (controller is PlanDetailController) ? "평가" : "댓글";
    return Column(
        children:
            (controller.comments.length > 0) ? buildComments() : Container());
  }

  List<Widget> buildComments() {
    List<Widget> commentTiles = [];

    for (int i = 0; i < controller.comments.length; i++) {
      print("널인가? ${controller.comments[i]}");
      commentTiles.add(buildCommentTile(controller.comments[i]));
    }
    return commentTiles;
  }

  buildCommentTile(c) {
  print("${c.state.toString()} 현 댓글 상태");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildNameNFeedback(c),
              Text(
                (c.state == 0)
                    ? c.content
                    : (c.state == 1) ? "블라인드 처리된 $str입니다." : "삭제된 $str입니다.",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(c.createAt),
              Divider(
                height: 1,
                color: Colors.white,
              ),
            ],
          ),
          color: CONTENT_COLOR,
        ),
      ),
    );
  }

  buildNameNFeedback(c) {
    print("여기는 오나?");
    return (c is Comment) ? boardCommentFeedback(c) :
    (c is PlanEvaluation) ? PlanCommentFeedback(c) : albumNCheerCommentFeedback(c);
//    switch (c){
//      case Comment:
//        return boardCommentFeedback(c);
//        break;
//      case PlanEvaluation :
//        print("여기는 오나?2");
//        return PlanCommentFeedback(c);
//        break;
//      case A_Comment :
//        return albumNCheerCommentFeedback(c);
//        break;
//    }
  }
//  buildNameNFeedback(c) {
//    return ConditionalBuilder(
//      condition: isBoard,
//      builder: (context) => boardCommentFeedback(c),
//      fallback: (context) => albumNCheerCommentFeedback(c),
//    );
//  }

  boardCommentFeedback(Comment c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ConditionalBuilder(
            condition: !(c.reRef == c.code),
            builder: (context) => Icon(Icons.subdirectory_arrow_right)),
        Expanded(
            child: Text(
          c.nickname,
          style: LITTLE_TEXT_STYLE,
        )),
        ConditionalBuilder(
            condition: (c.state == 0),
            builder: (context) => Row(
                  children: <Widget>[
                    commentFeedback(" 신고 ", c),
                    Text(c.reportCount.toString() + "  ",
                        style: LITTLE_TEXT_STYLE),
                  ],
                )),
        ConditionalBuilder(
            condition: (c.reRef == c.code),
            builder: (context) => commentFeedback(" 답글 ", c)),
        ConditionalBuilder(
            condition: (c.nickname == myUserName && c.state == 0),
            builder: (context) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    commentFeedback(" 수정 ", c),
                    commentFeedback(" 삭제 ", c)
                  ],
                )),
      ],
    );
  }

  albumNCheerCommentFeedback(c) {
    print("${c.Album_Account_AC_NickName} : $myUserName");
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Text(
          c.nickname,
          style: LITTLE_TEXT_STYLE,
        )),
        ConditionalBuilder(
            condition: (c.state == 0 && c.Album_Account_AC_NickName == myUserName && c.nickname != myUserName),
            builder: (context) =>
                commentFeedback(" 차단 ", c),
              ),
        ConditionalBuilder(
            condition: ((c.nickname == myUserName ||
                    controller.detail.nickname == myUserName) &&
                c.state == 0),
            builder: (context) =>
                    commentFeedback(" 수정 ", c),
        ),
        ConditionalBuilder(
          condition: ((c.nickname == myUserName ||
              controller.detail.nickname == myUserName ||
              c.Album_Account_AC_NickName == myUserName) &&
              c.state == 0),
          builder: (context) => commentFeedback(" 삭제 ", c),
        )
      ],
    );
  }
  PlanCommentFeedback(c) {
    print("${c.nickname} : $myUserName");
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Text(
              c.nickname,
              style: LITTLE_TEXT_STYLE,
            )),
        ConditionalBuilder(
          condition: (c.state == 0 && c.nickname != myUserName),
          builder: (context) =>
              commentFeedback(" 신고 ", c),
        ),
        ConditionalBuilder(
          condition: (c.nickname == myUserName && c.state == 0),
          builder: (context) =>
              commentFeedback(" 수정 ", c),
        ),
        ConditionalBuilder(
          condition: (c.nickname == myUserName && c.state == 0),
          builder: (context) => commentFeedback(" 삭제 ", c),
        )
      ],
    );
  }

  commentFeedback(String text, c) {
    return GestureDetector(
        child: Text(text, style: LITTLE_TEXT_STYLE),
        onTap: () async {
          switch (text) {
            case " 신고 ":
              reportNBlack(text , c);
              break;
            case " 답글 ":
              commentBottomSheet(c.code);
              break;
            case " 수정 ":
              commentBottomSheet(c.code, c.content);
              break;
            case " 삭제 ":
              bool result = await yesOrNoDialog("$str 삭제", "$str${(str=='댓글') ? '을' : '를'} 삭제하시겠습니까?");
              if (result) {
                controller.removeComment(c.boardCode, c.code);
              }
              break;
            case " 차단 ":
              reportNBlack(text , c);
              break;
          }
        });
  }
  reportNBlack(text , c) async {
    bool result = await yesOrNoDialog("$str $text", "$str${(str=='댓글') ? '을' : '를'} $text하시겠습니까?");
    if (result)
      try {
        await controller.clickReportComment(
            c.code, controller.nowPage);
      } on DuplicationException {
        Get.snackbar("이미 $text된 $str", "이미 $text된 $str입니다.");
      }
  }

  commentBottomSheet([int code, String content]) {
    print(content);
    return Get.bottomSheet(
      Wrap(children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: CommentWriter(controller, code, content),
        ),
      ]),
      backgroundColor: BACKGROUND_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
    );
  }
}
