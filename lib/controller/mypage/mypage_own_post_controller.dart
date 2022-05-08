import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/board/post_list.dart';
import 'package:intl/intl.dart';

class MyPageOwnPostController extends GetxController {
  static MyPageOwnPostController get to => Get.find();

  List<PostL> userOwnList;
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
    await loadPostLists(false);
    scrollController.addListener(_scrollListener);
  }

  parsingList(postListsData) {
    for (var board in postListsData['boardList']) {
      PostL postL = PostL(
          board['BO_Code'],
          board['BO_Title'],
          DateFormat("yyyy-MM-dd HH:mm").format(
              DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                  .parseUTC(board['BO_Creation_Date'])
                  .toLocal()),
          board['BO_Hit'],
          board['BO_Report_Count'],
          board['BO_Healthsee_Count'],
          board['BO_Comment_Count'],
          board['BO_Writer_NickName'],
          board['BO_State']);
      this.userOwnList.add(postL);
    }
  }

  loadPostLists(bool isNext) async {
    var responseData;
    var url;
    if (!isNext) {
      this.userOwnList = [];

      url = 'http://$IP$BOARDLIST/users/?name=$nickname';
    } else {
      url = 'http://$IP$BOARDLIST/users/?name=$nickname&BO_Code=${endAt}';
    }
    responseData = await HttpController.to.httpManeger("GET", url);
    parsingList(responseData);
    leaves = responseData['boardCount'];
    if (leaves == null)
      noMore = true;
    else if (leaves <= 10) {
      noMore = true;
    } else
      noMore = false;
    if (this.userOwnList.isEmpty) return;
    endAt = this.userOwnList[userOwnList.length - 1].code;
    update();
    loading = false;
  }

  void _scrollListener() {
    if (noMore) return;
    if (loading) {
      return;
    }
    double isBottom = (scrollController.position.maxScrollExtent * 0.95);
    if (scrollController.offset > isBottom) {
      this.loading = true;
      if (!noMore) loadPostLists(true);
    }
  }
}
