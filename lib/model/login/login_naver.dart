import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:heathee/controller/account_controller.dart';

class NaverLogin {
  bool naverisLogin = false;
  String naveraccesToken;
  String naverexpiresAt;
  String navertokenType;
  String navername;
  String naverrefreshToken;

  naverLoginPressed() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    navername = res.account.nickname;
    naverisLogin = true;
    // print(res.account.name + res.account.email);
    await buttonGetUserPressed();
  }

  Future<void> buttonTokenPressed() async {
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    naveraccesToken = res.accessToken;
    navertokenType = res.tokenType;
  }

  Future<void> buttonLogoutPressed() async {
    FlutterNaverLogin.logOut();
    naverisLogin = false;
    naveraccesToken = null;
    navertokenType = null;
    navername = null;
  }

  buttonGetUserPressed() async {
    try {
      NaverAccountResult res = await FlutterNaverLogin.currentAccount();
      print('naver에서 건진 계정정보 : ' + res.name);
      AccountController.to.storePlatformData(res.email, 'naver', res.name);
    } catch (e) {
      print('문제 발생 naver getUser' + e.toString());
    }
  }
}
