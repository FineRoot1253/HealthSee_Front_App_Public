import 'package:flutter/material.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/controller/theme_controller.dart';
import 'package:heathee/keyword/app_theme.dart';

import 'package:heathee/model/auth/member.dart';
import 'package:heathee/model/util/binding.dart';
import 'package:heathee/route/routes.dart';
import 'package:heathee/screen/auth/sign_in_page.dart';
import 'package:get/get.dart';
import 'package:heathee/screen/main_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'model/login/login.dart';
import 'package:heathee/keyword/key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var status = await Permission.camera.status;
  if (status.isUndetermined) {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera, Permission.storage].request();
  } else if (await Permission.camera.isPermanentlyDenied) {
    openAppSettings();
  }
  Get.put<ThemeController>(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Login login = Login();
  final HttpController httpController = Get.put(HttpController());
  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      title: 'Heath & See Demo',
      home: FutureBuilder(
          future: AccountController.to.readAll(),
          builder: (context, snapshot1) {
            if ((snapshot1.connectionState != ConnectionState.done)) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot1.connectionState == ConnectionState.done) {
              if (snapshot1.data.length > 1) {
                AccountController.to.setMember(
                    nickname: snapshot1.data[KEYNICKNAME],
                    platform: snapshot1.data[KEYPLATFORM],
                    email: snapshot1.data[KEYEMAIL]);
                return FutureBuilder<Member>(
                  future: AccountController.to.checkUser(snapshot1.data),
                  builder: (context, snapshot) {
                    if (!(snapshot.connectionState == ConnectionState.done))
                      return Center(child: CircularProgressIndicator());
                    if ((snapshot.connectionState == ConnectionState.done)) {
                      return MainPage();
                    }
                    if (snapshot.hasError) {
                      print("에러시 실행");
                      login.logout();
                      AccountController.to.clearUserData();
                      return SigninPage();
                    }
                    return SigninPage();
                  },
                );
              }
              return SigninPage();
            }
            return SigninPage();
          }),
      getPages: routes,
    );
  }
}
