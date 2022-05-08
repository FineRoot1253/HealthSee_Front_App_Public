import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_list_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/screen/board/widget/board_list_widget.dart';

class BoardListPage extends StatelessWidget {
  int selectedIndex = 0;
  PostListController postLists = PostListController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    //  category = Get.parameters['category'];

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })
        ],
        title: Text("자유게시판 글 목록"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey[900],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: CONTENT_COLOR,
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(
              activeIcon: Icons.home, icon: Icons.home, title: '홈'),
          _buildBottomNavigationBarItem(
              activeIcon: null, icon: Icons.search, title: '검색'),
          _buildBottomNavigationBarItem(
              activeIcon: null, icon: Icons.create, title: '글쓰기'),
        ],
        currentIndex: selectedIndex,
        onTap: (index) => onItemTapped(index),
      ),
      body: GetBuilder<PostListController>(
        init: PostListController(),
        initState: (_) {
          Get.find<PostListController>().init();
        },
        builder: (_) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              Get.find<PostListController>().refreshPostLists();
            },
            child: PostListWidget(
                posts: Get.find<PostListController>().postLists,
                controller: Get.find<PostListController>().scrollController),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {IconData activeIcon, IconData icon, String title}) {
    return BottomNavigationBarItem(
      activeIcon:
          (activeIcon != null) ? Icon(activeIcon, color: Colors.white) : null,
      icon: Icon(icon),
      title: Text(title),
    );
  }

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed("/boardSearch");
        break;
      case 2:
        Get.toNamed("/boardWrite");
        break;
    }
  }
}
