import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/screen/mypage/widget/user_own_comment.dart';
import 'package:heathee/screen/mypage/widget/user_own_post.dart';

class MyPageUserOwnBoard extends StatefulWidget {
  @override
  _MyPageUserOwnBoardState createState() => _MyPageUserOwnBoardState();
}

class _MyPageUserOwnBoardState extends State<MyPageUserOwnBoard>
    with SingleTickerProviderStateMixin {
  String _username;
  TabController _tabController;
  int _nowIndex = 0;
  final List<Tab> _categorys = <Tab>[
    Tab(text: '게시글'),
    Tab(text: '댓글'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = Get.arguments;
    _tabController = TabController(
      vsync: this,
      length: _categorys.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_username님의 게시판 활동"),
        bottom: TabBar(
          controller: _tabController,
          tabs: _categorys,
          onTap: (index) {
            setState(() {
              _nowIndex = _tabController.index;
            });
          },
        ),
      ),
      body: IndexedStack(
        index: _nowIndex,
        children: <Widget>[
          UserOwnPost(
            nickname: _username,
          ),
          UserOwnComment(
            nickname: _username,
          ),
        ],
      ),
    );
  }
}
