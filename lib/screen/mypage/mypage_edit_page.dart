import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/mypage/mypage_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/widget/dialog.dart';
import 'package:intl/intl.dart';

class MyPageEditPage extends StatefulWidget {
  @override
  _MyPageEditPageState createState() => _MyPageEditPageState();
}

class _MyPageEditPageState extends State<MyPageEditPage> {
  TextEditingController nickname = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController birth = TextEditingController();

  // Default : 남성, 공개
  bool gender;
  bool scope;
  bool isExist;
  DateTime _dateTime = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nickname.text = MyPageController.to.myUser.nickname;
    weight.text = MyPageController.to.myUser.weight.toString();
    height.text = MyPageController.to.myUser.height.toString();
    birth.text = (MyPageController.to.myUser.birth == null)
        ? DateFormat("yyyy/MM/dd").format(DateTime.now())
        : MyPageController.to.myUser.birth;
    gender = MyPageController.to.myUser.gender == 0 ? false : true;
    scope = MyPageController.to.myUser.scope == 0 ? false : true;
    MyPageController.to.isExist =
        (MyPageController.to.myUser.picture != null) ? true : false;
  }

  @override
  void dispose() {
    FocusScopeNode currentFocus = FocusScope.of(Get.context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    height?.dispose();
    weight?.dispose();
    nickname?.dispose();
    birth?.dispose();

    MyPageController.to.myUser.tempProfileImage = null;
    MyPageController.to.isExist =
        (MyPageController.to.myUser.nowProfileImage != null) ? true : false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CONTENT_COLOR,
          title: Text("프로필 수정"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await MyPageController.to.updateMyPage(
                      nickname.text,
                      (scope) ? 1 : 0,
                      (gender) ? 1 : 0,
                      weight.text,
                      height.text,
                      birth.text);
                })
          ],
        ),
        backgroundColor: BACKGROUND_COLOR,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  buildProfileChangeBtn(),
                  SizedBox(height: 10),
                  buildTextField(nickname, "별명", true),
                  SizedBox(height: 10),
                  buildTextField(weight, "체중", false),
                  SizedBox(height: 10),
                  buildTextField(height, "신장", false),
                  SizedBox(height: 10),
                  buildBirthField(birth, "생년월일", true),
                  SizedBox(height: 10),
                  buildGenderSwitch(),
                  SizedBox(height: 10),
                  buildScopeSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildScopeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text("공개범위",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'JUA',
                  fontStyle: FontStyle.normal)),
        ),
        Text("공개",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'JUA',
                fontStyle: FontStyle.normal)),
        Center(
          child: Switch(
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.blueAccent,
              activeColor: Colors.white,
              activeTrackColor: Colors.black,
              value: scope,
              onChanged: (_) {
                setState(() {
                  scope = !scope;
                });
              }),
        ),
        Text("비공개",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'JUA',
                fontStyle: FontStyle.normal)),
      ],
    );
  }

  Row buildGenderSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text("성별",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'JUA',
                  fontStyle: FontStyle.normal)),
        ),
        Text("남성",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'JUA',
                fontStyle: FontStyle.normal)),
        Center(
          child: Switch(
              inactiveThumbColor: Colors.blue,
              activeColor: Colors.pink,
              inactiveTrackColor: Colors.blueAccent,
              activeTrackColor: Colors.pinkAccent,
              value: gender,
              onChanged: (_) {
                setState(() {
                  gender = !gender;
                });
              }),
        ),
        Text("   여성",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'JUA',
                fontStyle: FontStyle.normal)),
      ],
    );
  }

  Widget buildProfileChangeBtn() {
    return GestureDetector(
      onTap: () async {
        await profileImgDialog();
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ConditionalBuilder(
                condition:
                    (MyPageController.to.myUser.tempProfileImage != null),
                builder: (context) {
                  return Container(
                    width: 175,
                    height: 175,
                    child: Image.file(
                      MyPageController.to.myUser.tempProfileImage,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                fallback: (context) {
                  return ConditionalBuilder(
                    condition: MyPageController.to.isExist,
                    builder: (context) {
                      return Container(
                        width: 175,
                        height: 175,
                        child: Image.memory(
                          MyPageController.to.myUser.picture,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    fallback: (context) {
                      return Container(
                        width: 175,
                        height: 175,
                        child: Image.asset(
                          'assets/image/profile_image/blank_profile_picture.jpg',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '프로필 사진 변경',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ]),
      ),
    );
  }

  TextFormField buildTextField(
      TextEditingController controller, String labelText, bool isReadOnly) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: () {},
      decoration: InputDecoration(
          labelText: labelText,
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

  TextFormField buildBirthField(
      TextEditingController controller, String labelText, bool isReadOnly) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: () {
        return dateBottomSheet();
      },
      decoration: InputDecoration(
          labelText: labelText,
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

  dateBottomSheet() {
    return Get.bottomSheet(
      Wrap(children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "생년월일 입력",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'JUA',
                    fontStyle: FontStyle.normal),
              ),
            ),
            SizedBox(
              height: 150,
              width: Get.width,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (dateTime) {
                  _dateTime = dateTime;
                },
                minimumYear: 1900,
                maximumYear: DateTime.now().year,
                initialDateTime:
                    DateTime.parse(MyPageController.to.myUser.birth),
              ),
            ),
            FlatButton(
                onPressed: () {
                  setState(() {
                    birth.text = DateFormat('yyyy-MM-dd').format(_dateTime);
                  });
                  Get.back();
                },
                color: Colors.blue,
                child: Text("제출",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'JUA',
                        fontStyle: FontStyle.normal))),
          ],
        )
      ]),
      backgroundColor: BACKGROUND_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
    );
  }
}
