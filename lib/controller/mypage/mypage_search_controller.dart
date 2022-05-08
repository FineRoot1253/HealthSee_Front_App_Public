import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/mypage/user.dart';
import 'package:intl/intl.dart';

class MyPageSearchController extends GetxController {
  static MyPageSearchController get to => Get.find();

  /// 받아오지 않은 잔여 리스트 개수
  int leaves;

  /// 로딩중인지 아닌지, 아닐 때 False
  bool loading = false;
  int endAt = -1;
  String keyword = "";
  bool noMore = false;

  List<User> userList = [];

  final scrollController = ScrollController(
    keepScrollOffset: true,
  );

  init({String keyword}) async {
    this.keyword = keyword;
    await loadUserLists(false);
    scrollController.addListener(_scrollListener);
  }

  reset() {
    if (this.userList.isNotEmpty) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      scrollController.removeListener(_scrollListener);
    }
    this.keyword = null;
    this.userList = [];
    update();
  }

  parsingList(userData) {
    for (var json in userData) {
      User user = User(
          json['ME_Code'] as int,
          json['Account_AC_NickName'] as String,
          json['ME_Scope'] as int,
          (json['ME_Profile_Photo'] != null)
              ? Uint8List.fromList(json['ME_Profile_Photo']['data'].cast<int>())
              : null,
          (json['ME_Profile_Photo'] != null) ? json['ME_Profile_Type'] : null);
      this.userList.add(user);
    }
  }

  Future<void> loadUserLists(bool isNext) async {
    var url;
    var responseData;
    if (!isNext) {
      this.userList = [];
      url = 'http://$IP$MYPAGE/?keyword=${keyword}';
    } else {
      url = 'http://$IP$MYPAGE/?keyword=${keyword}&ME_Code=${endAt}';
    }
    responseData = await HttpController.to.httpManeger('GET', url);

    parsingList(responseData['userList']);
    leaves = responseData['userCount'];

    if (leaves == null)
      noMore = true;
    else if (leaves <= 10) {
      noMore = true;
    } else
      noMore = false;

    if (this.userList.isEmpty) return;
    endAt = this.userList[userList.length - 1].code;
    update();
    loading = false;
  }

  Future<Null> refreshLists() async {
    if (this.userList.isNotEmpty) {
      scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    }

    this.loading = true;
    this.userList = [];
    await loadUserLists(false);
  }

  void _scrollListener() {
    if (noMore) return;
    if (loading) {
      return;
    }
    double isBottom = (scrollController.position.maxScrollExtent * 0.95);
    if (scrollController.offset > isBottom) {
      this.loading = true;
      if (!noMore) loadUserLists(true);
    }
  }
}
