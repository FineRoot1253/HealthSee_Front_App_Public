import 'package:heathee/controller/account_controller.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';

class KakaoLogin {
  User user;

  bool _isKakaoTalkInstalled = true;

  bool get getIskakaoinst => _isKakaoTalkInstalled;

  initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    _isKakaoTalkInstalled = installed;
  }

  _issueAccessToken(String authCode) async {
    try {
      print('토큰 얻어오는중');
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print(token);
    } catch (e) {
      print('문제발생accesstoken:' + e.toString());
    }
  }

  loginWithkakao() async {
    try {
      print('웹카카오로긴시작');
      var code = await AuthCodeClient.instance.request();
      print("auth코드:" + code);
      await _issueAccessToken(code);
      await kakaogetUser();
    } catch (e) {
      print('문제발생kakao:' + e.toString());
    }
  }

  loginWithTalk() async {
    try {
      print('카톡로긴시작');
      var code = await AuthCodeClient.instance.requestWithTalk();
      print("auth코드:" + code);
      await _issueAccessToken(code);
      //await retryAfterUserAgrees(["account_email"]);
      await kakaogetUser();
    } catch (e) {
      print('문제발생talk:' + e.toString());
    }
  }

  retryAfterUserAgrees(List<String> requiredScopes) async {
    // Getting a new access token with current access token and required scopes.
    String authCode =
        await AuthCodeClient.instance.requestWithAgt(requiredScopes);
    AccessTokenResponse token =
        await AuthApi.instance.issueAccessToken(authCode);
    AccessTokenStore.instance.toStore(
        token); // Store access token in AccessTokenStore for future API requests.
    await kakaogetUser();
  }

  kakaogetUser() async {
    try {
      user = await UserApi.instance.me();
      if (user.kakaoAccount.emailNeedsAgreement) {
        await retryAfterUserAgrees(["account_email"]);
      }
      AccountController.to.storePlatformData(
          user.kakaoAccount.email, 'kakao', user.kakaoAccount.profile.nickname);
    } catch (e) {
      print("문제 발생 kakao getUser : " + e.toString());
    }
  }
}
