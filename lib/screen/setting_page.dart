import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/theme_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/model/login/login.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/model/util/menu_option_model.dart';
import 'package:heathee/widget/segmented_selector.dart';

class SettingPage extends StatelessWidget {
  Login login = Login();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    await HttpController.to
                        .httpManeger("POST", "http://$IP/auth/logout");
                    await login.logout();
                    await AccountController.to.clearUserData();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text('통합 로그아웃'),
                ),
                RaisedButton(
                    child: Text("토큰 체크"),
                    onPressed: () async {
                      try {
                        checkGet();
                      } on TokenTimeOutException {
                        Get.snackbar("이런...", "유지실패입니다");
                      }
                    }),
                themeListTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  themeListTile() {
    final List<MenuOptionsModel> themeOptions = [
      MenuOptionsModel(
          key: "system", value: "시스템 테마", icon: Icons.brightness_4),
      MenuOptionsModel(
          key: "light", value: "밝은 테마", icon: Icons.brightness_low),
      MenuOptionsModel(key: "dark", value: "어두운 테마", icon: Icons.brightness_3)
    ];
    return GetBuilder<ThemeController>(
      builder: (controller) => ListTile(
        title: Text("테마"),
        trailing: SegmentedSelector(
          selectedOption: controller.currentTheme,
          menuOptions: themeOptions,
          onValueChanged: (value) {
            controller.setThemeMode(value);
          },
        ),
      ),
    );
  }

  checkGet() async {
    var res =
        await HttpController.to.httpManeger("GET", "http://$IP/auth/check");
    if (res == "timeout") {
      throw TokenTimeOutException();
    }
    Get.snackbar("축하!", "유지중입니다");
  }
}
