import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/key.dart';
import 'package:heathee/model/auth/member.dart';
import 'package:heathee/model/auth/platform_data.dart';
import 'package:heathee/model/util/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  static AccountController get to => Get.find();
  final storage = FlutterSecureStorage();
  SharedPreferences sharedPreferences;
  PlatformData _myPlatformData;
  Member _member;
  Future<Map<String, String>> accountMap;
  Map<String, String> _getHeader;
  get getHeader => _getHeader;
  Map<String, String> _postHeader;
  get postHeader => _postHeader;
  get nickname => _member.nickname;
  get email => _myPlatformData.email;
  get myPlatformData => _myPlatformData;
  get myMember => _member;

  static const platform = const MethodChannel("com.hjp");
  void Printy() async {
    String value;
    try {
      value = await platform.invokeMethod("Printy");
    } catch (e) {
      print(e);
    }
    print(value);
  }

  Future<Map<String, String>> readAll() {
    return accountMap = storage.readAll() ?? {"NOLOGIN": "NOLOGIN"};
  }

  setToken(Map<String, String> token) {
    token.forEach((key, value) async {
      await storage.write(key: key, value: value);
    });
  }

  setHeader(Map<String, String> token) async {
    token.forEach((key, value) async {
      await storage.write(key: key, value: value);
    });

    _getHeader = {
      "Content-Type": "application/json",
      'cookie': "access_token=" +
          token[KEYACCESSTOKEN] +
          ";refresh=" +
          token[KEYREFRESHTOKEN]
    };
    _postHeader = {
      'cookie': "access_token=" +
          token[KEYACCESSTOKEN] +
          ";refresh=" +
          token[KEYREFRESHTOKEN]
    };
  }

  storePlatformData(String email, String platform, [String name]) async {
    _myPlatformData = PlatformData(email, platform, name);
    if (name != null) await storage.write(key: KEYNAME, value: name);
    await storage.write(key: KEYEMAIL, value: email);
    await storage.write(key: KEYPLATFORM, value: platform);
  }

  setMember(
      {String platform,
      String email,
      String nickname,
      String name,
      int scope,
      int gender,
      double weight}) {
    _member =
        Member(nickname, email, platform, name, "Phone", scope, gender, weight);
  }

  setUserData(String nickname, String email, String platform) async {
    print("실행체크");
    await storage.write(key: KEYNICKNAME, value: nickname);
    await storage.write(key: KEYEMAIL, value: email);
    await storage.write(key: KEYPLATFORM, value: platform);
  }

  clearUserData() async {
    _myPlatformData = null;
    _member = null;
    // await sharedPreferences?.clear();
    await storage.deleteAll();
    print("초기화");
  }

  Future<Member> checkUser(Map<String, String> token) async {
    await setHeader(token);
    var res =
        await HttpController.to.httpManeger("GET", "http://$IP/auth/check");
    if (res == "timeout") {
      throw TokenTimeOutException();
    }
    String platform = await storage.read(key: KEYPLATFORM);

    if (!(nickname == res['user']['username'])) {
      print("가지고 있는 계정 정보가 다릅니다.");
      this.storePlatformData(res['user']['email'], platform);
      this.setMember(nickname: res['user']['username']);
    }
    return _member;
  }
}
