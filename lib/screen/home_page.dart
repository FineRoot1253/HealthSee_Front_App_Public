import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/keyword/color.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SafeArea(
        child: Center(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[courseLearn(), exerciseByCourse()],
            ),
            userProgress(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: Get.width * 0.85,
                  height: Get.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CONTENT_COLOR,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[userAlbum(), userExercise()],
                  )),
            ),
          ],
        )),
      ),
    );
  }

  userProgress() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 0.85,
        height: Get.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CONTENT_COLOR,
        ),
        child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            color: CONTENT_COLOR,
          ),
//          child: Column(
//            mainAxisSize: MainAxisSize.min,
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(left: 8.0),
//                child: Row(
//                  mainAxisSize: MainAxisSize.min,
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    Expanded(
//                      child: Text(
//                        "진행도",
//                        style: TextStyle(
//                            fontFamily: "JUA",
//                            fontSize: 25,
//                            color: Colors.white),
//                      ),
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.add),
//                      iconSize: 35,
//                      color: Colors.white,
//                      onPressed: () {
//                        setState(() {
//                          items.add('default');
//                        });
//                      },
//                    )
//                  ],
//                ),
//              ),
//              (items.length == 0)
//                  ? Text(
//                "+를 눌러 목표를 추가해보세요",
//                style: TextStyle(
//                    fontFamily: "JUA", fontSize: 20, color: Colors.white),
//              )
//                  : Flexible(
//                child: Container(
//                  child: ListView.builder(
//                      scrollDirection: Axis.vertical,
//                      shrinkWrap: true,
//                      itemBuilder: (context, index) {
//                        if (index < items.length) {
//                          return progressTile(items[index]);
//                        }
//                        return Container(
//                          width: 0.0,
//                          height: 0.0,
//                        );
//                      }),
//                ),
//              )
//            ],
//          ),
        ),
      ),
    );
  }

  exerciseByCourse() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: Get.width * 0.4,
        height: Get.height * 0.125,
        child: RaisedButton(
          onPressed: () => Get.toNamed("/planMain"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: Text('코스에 맞춰\n운동하기',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'JUA',
                  fontStyle: FontStyle.normal)),
        ),
      ),
    );
  }

  userExercise() {
    return Expanded(
      flex: 5,
      child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            color: CONTENT_COLOR,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "나만의 운동",
                      style: TextStyle(
                          fontFamily: "JUA", fontSize: 12, color: Colors.white),
                    )),
                    IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 25,
                      color: Colors.white,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Text(
                "+를 눌러 운동을 추가해보세요",
                style: TextStyle(
                    fontFamily: "JUA", fontSize: 12, color: Colors.white),
              )
            ],
          )),
    );
  }

  courseLearn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: Get.width * 0.4,
        height: Get.height * 0.125,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          child: Text('동작 배우기',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'JUA',
                  fontStyle: FontStyle.normal)),
        ),
      ),
    );
  }

  userAlbum() {
    return Expanded(
      flex: 5,
      child: Container(
          width: Get.width,
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            color: CONTENT_COLOR,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "앨범",
                        style: TextStyle(
                            fontFamily: "JUA",
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 25,
                      color: Colors.white,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
//              GetBuilder<Photo>(
//                init: Photo(),
//                builder: (_) {
//                  return FutureBuilder(future: Get.putAsync(() async {
//                    final prefs = await SharedPreferences.getInstance();
//                    return prefs;
//                  }), builder: (context, snapshot) {
//                    if (snapshot.hasData == false) {
//                      return Center(child: CircularProgressIndicator());
//                    } else {
//                      Photo.to.sharedPreferences = snapshot.data;
//                      return FutureBuilder(
//                          future: Photo.to.loadPhoto(KEYMONTH),
//                          builder: (context, snapshot2) {
//                            if (snapshot2.hasData == false) {
//                              return Center(
//                                child: CircularProgressIndicator(),
//                              );
//                            } else {
//                              if (snapshot2.data.toString().compareTo('0') !=
//                                  0) {
//                                return Container(
//                                  height: size.height * 0.13,
//                                  width: size.width * 0.3,
//                                  child: ListView.builder(
//                                      shrinkWrap: true,
//                                      scrollDirection: Axis.horizontal,
//                                      itemCount: snapshot2.data.length,
//                                      itemBuilder: (context, index) {
//                                        return FutureBuilder(
//                                            future: albumChosenCallTile(
//                                                KEYMONTH, index),
//                                            builder: (context, snapshot3) {
//                                              if (snapshot3.data != null) {
//                                                return snapshot3.data;
//                                              }
//                                              return Text(
//                                                "+를 눌러 사진을 추가해보세요",
//                                                style: TextStyle(
//                                                    fontFamily: "JUA",
//                                                    fontSize: 12,
//                                                    color: Colors.white),
//                                              );
//                                            });
//                                      }),
//                                );
//                              } else {
//                                return Text(
//                                  "+를 눌러 사진을 추가해보세요",
//                                  style: TextStyle(
//                                      fontFamily: "JUA",
//                                      fontSize: 12,
//                                      color: Colors.white),
//                                );
//                              }
//                            }
//                          });
//                    }
//                  });
//                },
//              )
            ],
          )),

    );
  }
  handleBanError(e) {
    Get.snackbar("경고", "당신은 앨범주인의 요청에 의해 차단되었습니다");
  }
  handleError(e) {
    Get.snackbar("경고", "원인 모를 에러가 발생했습니다.");
  }
}
