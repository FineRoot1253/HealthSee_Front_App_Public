import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heathee/model/login/login.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  Login login;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login = Login();

//    Future.delayed(Duration.zero, () {
//      login.initKakao();
//      print(login.getIskakao);
//    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    KakaoContext.clientId = "98b738306bbb1235c67b916a8e0c85c6";

    return Scaffold(
        backgroundColor: Color(0xff7C8395),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              signuptitle(),
              Padding(
                padding: EdgeInsets.all(size.width * 0.1),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: kakaoBtn(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: naverBtn(),
                    ),
                    googleBtn(size),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  GestureDetector kakaoBtn() {
    return GestureDetector(
        onTap: () async {
          login.login("kakao");
        },
        child: Image.asset(
          'assets/image/kakao_login_btn_medium_wide.png',
          height: 48.0,
          width: 265,
          fit: BoxFit.fill,
        ));
  }

  GestureDetector naverBtn() {
    return GestureDetector(
      onTap: () async {
        login.login("naver");
      },
      child: Image.asset(
        'assets/image/naver_login_btn_full.png',
        height: 48.0,
        width: 265,
        fit: BoxFit.fill,
      ),
    );
  }

  RaisedButton googleBtn(Size size) {
    return RaisedButton(
      padding: EdgeInsets.all(size.width * 0.005),
      color: const Color(0xFF4285F4),
      onPressed: () async {
        login.login("google");
//          login.login(3)
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/image/btn_google_signin_dark_focus_mdpi.9.png',
            height: 48.0,
          ),
          Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Text(
                "Sign in with Google",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Text signuptitle() {
    return Text(
      '로그인',
      style: TextStyle(
          fontSize: 35,
          color: Colors.white,
          fontFamily: 'JUA',
          fontStyle: FontStyle.normal),
      textAlign: TextAlign.end,
    );
  }
}
