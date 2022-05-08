import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/key.dart';
import 'package:heathee/model/auth/platform_data.dart';
import 'package:heathee/model/login/login_google.dart';
import 'package:heathee/model/login/login_kakao.dart';
import 'package:heathee/model/login/login_naver.dart';

import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  String platform;
  String name;
  String email;
  int platformint;
  KakaoLogin kakaoLogin = KakaoLogin();
  NaverLogin naverLogin = NaverLogin();
  GoogleLogin googleLogin = GoogleLogin();
  List<String> platformList = ["kakao", "naver", "google"];
  String platformString;
  //platformString = platformList[_platform + 1];
  AccountController accountController = Get.put(AccountController());

  // for kakao login
  bool get getIskakao => kakaoLogin.getIskakaoinst;
  Future<bool> initKakao() async => await kakaoLogin.initKakaoTalkInstalled();
  PlatformData userdetail;
  login(String platform) async {
//    await SharedPreferences.putPlatformInfo(platform);
    int index = platformList.indexOf(platform);
    switch (index) {
      case 0:
        initKakao();
        (getIskakao)
            ? await kakaoLogin.loginWithTalk()
            : await kakaoLogin.loginWithkakao();
        break;
      case 1:
        await naverLogin.naverLoginPressed();
        break;
      case 2:
        await googleLogin.handleSignIn();
        break;
      default:
        break;
    }
    userdetail = AccountController.to.myPlatformData;
    print("유저 정보" + userdetail.toString());
    var res = await HttpController.to
        .httpManeger("POST", "http://$IP/auth/login", userdetail.toJson());
    if (res == "signup") {
      Get.toNamed('/signup/$platform');
    } else {
      print(res['username'] + "돌려 받은 닉네임");
      AccountController.to
          .setMember(platform: platform, nickname: res['username']);
      await AccountController.to
          .setUserData(res['username'], res['email'], platform);

      print("로그인 완료");
      Get.offAllNamed('/main');
    }

//  var result = await userAdd('/login', userdetail);
//    if (result.ok) {
//      platformint = Get.find<AccountController>().sharedPreferences.getInt('platform');
//      print("로그인 완료 : $platformint");
//    } else {
//      Get.toNamed('/signup', arguments: userdetail);
//      Navigator.of(context).pushNamed('/signup', arguments: userdetail);
//    }
  }

  // 통합 로그아웃 버튼용
  logout() async {
    String platform = await AccountController.to.storage.read(key: KEYPLATFORM);
    print("로그아웃 ${AccountController.to.nickname}");
    if(AccountController.to.nickname != null) {
      switch (platform) {
        case 'kakao':
          try {
            await UserApi.instance.unlink();
          } catch (e) {
            print("로그아웃중 에러발생 : ${e.toString()}");
          }
          await AccessTokenStore.instance.clear();
          break;
        case 'naver':
          await naverLogin.buttonLogoutPressed();
          break;
        case 'google':
          await googleLogin.handleSignOut();
          break;
        default:
          break;
      }
    }
    AccountController.to.storePlatformData("", "", "");
    Get.offAllNamed('/signin');
  }
}
