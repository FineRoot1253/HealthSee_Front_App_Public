import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/board/post_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class PostSearchController extends GetxController {
  // 운동 or 자유게시판 중 어떤 게시판인지
  //static PostSearchController get to => Get.find();

  String name;
  String keyword;
  int endAt = -1;
  bool loading = false;
  int leaves;
  bool noMore = false;
  List<PostL> postLists = [];
  final scrollController = ScrollController(
    keepScrollOffset: true,
  );
  reset() {
    if (this.postLists.isNotEmpty) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      // scrollController.removeListener(_scrollListener);
    }
    this.name = null;
    this.keyword = null;
    this.postLists = [];
    update();
  }

  init({String name, String keyword}) async {
    this.name = name;
    this.keyword = keyword;
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
      this.postLists.add(postL);
    }
  }

  loadPostLists(bool isNext) async {
    var url;
    var responseData;
    if (!isNext) {
      this.postLists = [];
      url = 'http://$IP$BOARDLIST/?name=${name}&keyword=${keyword}';
    } else {
      url =
          'http://$IP$BOARDLIST/?name=${name}&keyword=${keyword}&BO_Code=${endAt}';
    }
    responseData = await HttpController.to.httpManeger('GET', url);
    parsingList(responseData);
    leaves = responseData['boardCount'];

    if (leaves == null)
      noMore = true;
    else if (leaves <= 10) {
      noMore = true;
    } else
      noMore = false;

    if (this.postLists.isEmpty) return;
    endAt = this.postLists[postLists.length - 1].code;
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
