import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/model/login/login.dart';
import 'package:heathee/screen/board/board_main_page.dart';
import 'package:heathee/screen/home_page.dart';
import 'package:heathee/screen/mypage/mypage_my_page.dart';
import 'package:heathee/screen/search_page.dart';
import 'package:heathee/screen/setting_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AlbumMainController albumMainController = Get.put(AlbumMainController());
  AccountController accountController = Get.put(AccountController());
  Map<String, String> accountMap;
  Map<String, String> tokenMap;
  Login login = Login();
  int _widgetIndex = 2;
  final List<String> items = List<String>();
  int platform;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            onTap: _onTap,
            currentIndex: _widgetIndex,
            items: [
              buildBottomNavigationBarItem(Icons.person_outline, Icons.person),
              buildBottomNavigationBarItem(
                  Icons.people_outline, Icons.person_add),
              buildBottomNavigationBarItem(Icons.home, Icons.home),
              buildBottomNavigationBarItem(
                  Icons.chat_bubble_outline, Icons.chat_bubble),
              buildBottomNavigationBarItem(Icons.settings, Icons.settings),
            ]),
        body: IndexedStack(
          index: _widgetIndex,
          children: <Widget>[
            MyPageMainPage(AccountController.to.nickname),
            SearchPage(),
            HomePage(), //메인 페이지
            BoardMainPage(), // 게시판 페이지
            SettingPage(),
          ],
        ));
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData icon, IconData activeIcon) {
    return BottomNavigationBarItem(
      backgroundColor: CONTENT_COLOR,
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      title: Text(""),
    );
  }

  _onTap(int index) {
    if (_widgetIndex != index) setState(() => _widgetIndex = index);
  }
}
