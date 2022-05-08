import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/model/auth/member.dart';
import 'package:heathee/model/util/error.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //User user = AccountController.to.myuser;
  Member myMember;
  double changeW = 0;
  // 남자 false 비공개 false
  bool gender = false;
  bool scope = false;
  String genderStr = "남성";
  String scopeStr = "공개";
  String _platform = Get.parameters['platform'];

  TextEditingController _textNickNameController = TextEditingController();
  TextEditingController _textWeightController = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff7C8395),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '회원 가입',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontFamily: 'JUA',
                  fontStyle: FontStyle.normal),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: loginForm(myMember),
            ),
            submitBtn(),
          ],
        ));
  }

  Widget loginForm(Member userAccount) {
    return Form(
        key: _formkey,
        child: Column(children: <Widget>[
          nicknameField(),
          weightField(),
          Padding(
            padding: const EdgeInsets.only(left: 45, top: 15.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                subtitleRow(),
                Row(children: <Widget>[
                  //Text("남성"),
                  genderSwitch(),
                  Container(
                    width: 160,
                  ),
                  scopeSwitch(),
                ]),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                    ),
                    Text(genderStr),
                    Container(
                      width: 200 + changeW,
                    ),
                    Text(scopeStr),
                  ],
                ),
              ],
            ),
          )
        ]));
  }

  TextFormField nicknameField() {
    return TextFormField(
      controller: _textNickNameController,
      decoration: InputDecoration(
          icon: Icon(Icons.account_circle),
          labelText: '닉네임',
          labelStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'JUA',
              fontStyle: FontStyle.normal),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          )),
      validator: (String value) {
        if (value.isEmpty) return "닉네임을 입력해주세요";
        return null;
      },
    );
  }

  TextFormField weightField() {
    return TextFormField(
      controller: _textWeightController,
      decoration: InputDecoration(
          icon: Icon(Icons.accessibility),
          labelText: '몸무게',
          labelStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'JUA',
              fontStyle: FontStyle.normal),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          )),
      validator: (String value) {
        if (value.isEmpty) return "몸무게를 입력해주세요";
        return null;
      },
      keyboardType: TextInputType.number,
    );
  }

  Row subtitleRow() {
    return Row(
      children: <Widget>[
        Container(
          width: 10,
        ),
        Text(
          "성별",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'JUA',
              fontStyle: FontStyle.normal),
        ),
        Container(
          width: 160,
        ),
        Text("비공개 여부",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'JUA',
                fontStyle: FontStyle.normal))
      ],
    );
  }

  Switch genderSwitch() {
    return Switch(
      value: gender,
      inactiveTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.blue,
      onChanged: (value) {
        setState(() {
          gender = value;
          genderStr = (value) ? "여성" : "남성";
        });
      },
      activeTrackColor: Colors.pinkAccent,
      activeColor: Colors.pink,
    );
  }

  Switch scopeSwitch() {
    return Switch(
      value: scope,
      inactiveTrackColor: Colors.blueAccent,
      inactiveThumbColor: Colors.blue,
      onChanged: (value) {
        setState(() {
          scope = value;
          scopeStr = value ? "공개" : "비공개";
          changeW = value ? -5 : 0;
        });
      },
      activeTrackColor: Colors.pinkAccent,
      activeColor: Colors.pink,
    );
  }

  RaisedButton submitBtn() {
    return RaisedButton(
      color: Colors.blue,
      child: Text('확인',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'JUA',
              fontStyle: FontStyle.normal)),
      onPressed: () async {
        if (_formkey.currentState.validate()) {
          try {
            print(AccountController.to.myPlatformData.name+"asdfasdf");
            AccountController.to.setMember(
                nickname: _textNickNameController.text,
                platform: _platform,
                scope: (scope) ? 1 : 0,
                gender: (gender) ? 1 : 0,
                weight: double.parse(_textWeightController.text),
                name: AccountController.to.myPlatformData.name,
                email: AccountController.to.myPlatformData.email);
            myMember = AccountController.to.myMember;

            var res = await postUser(myMember);
            print('프로바이더 오브');
            print(res);
            await AccountController.to
                .setUserData(res['username'], res['email'], _platform);
            Get.snackbar("환영", "회원가입을 환영합니다.");
            Get.back();
            Get.offAllNamed('/main');
          } on DuplicationException {
            Get.snackbar("닉네임 중복", "중복된 닉네임 입니다.");
          } on Exception {
            Get.snackbar("에러발생", "예기치 못한 에러가 발생했습니다.");
          }
        }
      },
    );
  }

  postUser(member) async {
    var res = await HttpController.to
        .httpManeger("POST", "http://$IP/auth/register", member.toJson());
    if (res == "duplicate") {
      throw DuplicationException();
    }
    return res;
  }
}
