import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/model/auth/member.dart';
import 'package:heathee/screen/board/widget/board_comment_widget.dart';
import 'package:heathee/screen/board/widget/board_detail_widget.dart';

class BoardDetailPage extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController comment = TextEditingController();
  PostDetailController postDetailController;
  Member myUser;

  @override
  Widget build(BuildContext context) {
    postDetailController = Get.arguments;
    myUser = AccountController.to.myMember;
    return GetBuilder<PostDetailController>(
      init: PostDetailController(
          postDetailController.detail,
          postDetailController.comments,
          postDetailController.fileList,
          postDetailController.lastPage,
          postDetailController.isHealthsee,
          postDetailController.isReport,
          postDetailController.commentCount),
      builder: (_) {
        return Scaffold(
            appBar: AppBar(
              title: Text(_.detail.title),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {},
              child: SafeArea(
                child: SingleChildScrollView(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        BoardDetailWidget(_),
                        Divider(
                          height: 1.0,
                          color: Colors.white60,
                        ),
                        BoardCommentWidget(_)
                      ],
                    ),
                  ),
                )),
              ),
            ));
      },
    );
  }
}
