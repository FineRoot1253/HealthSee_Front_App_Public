import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/board/comment.dart';
import 'package:intl/intl.dart';

class MyPageOwnCommentController extends GetxController {
  static MyPageOwnCommentController get to => Get.find();

  List<Comment> userOwnList;
  bool noMore;
  bool loading;
  int endAt = -1;
  int leaves;
  String nickname;

  final scrollController = ScrollController(
    keepScrollOffset: true,
  );

  init(String nickname) async {
    this.nickname = nickname;
    await loadCommentLists(false);
    scrollController.addListener(_scrollListener);
  }

  loadCommentLists(bool isNext) async {
    var responseData;
    var url;
    if (!isNext) {
      this.userOwnList = [];

      url = 'http://$IP$BOARDPOST/users/?name=$nickname';
      print(url);
    } else {
      url = 'http://$IP$BOARDPOST/users/?name=$nickname&BC_Code=${endAt}';
    }
    responseData = await HttpController.to.httpManeger("GET", url);
    parsingComment(responseData['comments']);
    leaves = responseData['commentsCount'];
    if (leaves == null)
      noMore = true;
    else if (leaves <= 20) {
      noMore = true;
    } else
      noMore = false;
    if (this.userOwnList.isEmpty) return;
    endAt = this.userOwnList[userOwnList.length - 1].code;
    update();
    loading = false;
  }

  parsingComment(comments) {
    loading = true;

    for (var co in comments) {
      Comment comment = Comment(
          co['BC_Code'],
          co['BC_Content'],
          DateFormat("yyyy-MM-dd HH:mm").format(
              DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                  .parseUTC(co['BC_Creation_Date'])
                  .toLocal()),
          co['BC_Re_Ref'],
          co['Board_BO_Code'],
          co['BC_Writer_NickName'],
          co['BC_Report_Count'],
          co['BC_State']);
      userOwnList.add(comment);
    }
  }

  void _scrollListener() {
    if (noMore) return;
    if (loading) {
      return;
    }
    double isBottom = (scrollController.position.maxScrollExtent * 0.95);
    if (scrollController.offset > isBottom) {
      this.loading = true;
      if (!noMore) loadCommentLists(true);
    }
  }
}
