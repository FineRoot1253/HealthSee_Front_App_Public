import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:get/get.dart';
import 'package:heathee/keyword/key.dart';
import 'package:heathee/model/album/album_list.dart';
import 'package:heathee/screen/album/album_sliver_list_widget.dart';
import 'package:heathee/screen/album/widget/album_button_bar.dart';

class MyAlbumPage extends StatefulWidget {
  @override
  _MyAlbumPageState createState() => _MyAlbumPageState();
}

class _MyAlbumPageState extends State<MyAlbumPage> {
  String appBarStr = '편집';
  List<String> month;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future<dynamic> result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    if(Get. = )
    AlbumMainController.to.albumListController.year = NOWYEAR;
    AlbumMainController.to.albumListController.currentNickname =
        AccountController.to.nickname;
  }

  @override
  Widget build(BuildContext context) {
    print("리빌드 test");
    return Container(
        height: Get.height * 0.8,
        width: Get.width,
        child: GetBuilder<AlbumMainController>(
            init: AlbumMainController(),
            initState: (_) async {
              result =
                  AlbumMainController.to.init(AccountController.to.nickname);
            },
            builder: (_) {
              return Scaffold(
                  backgroundColor: BACKGROUND_COLOR,
                  appBar: commonAppBar(),
                  body: FutureBuilder(
                      future: result,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AlbumMenuBar(
                                  AlbumMainController.to,
                                  _.albumListController.year.toString() + "년",
                                  "선택"),
                              Expanded(
                                  child: monthBarColumn(_.albumListController)),
                            ],
                          );
                        else if (snapshot.hasError)
                          return Column(children: <Widget>[
                            Text("오류발생 \n ${snapshot.error.toString()}"),
                            RaisedButton(child: Text("확인"))
                          ]);
                        else
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                      }));
            }));
  }

  commonAppBar() {
    return AppBar(
      backgroundColor: CONTENT_COLOR,
      leading: IconButton(
        color: Colors.black,
        icon: Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      title: Text(
        '앨 범',
        style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'JUA',
            fontStyle: FontStyle.normal),
      ),
      centerTitle: true,
      actions: <Widget>[
        RaisedButton(
          child: Text(
            appBarStr,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'JUA',
                fontStyle: FontStyle.normal),
          ),
          onPressed: () {
            setState(() {
              if (appBarStr.compareTo('편집') == 0) {
                this.appBarStr = '완료';
                AlbumMainController.to.setMode(true);
              } else {
                this.appBarStr = '편집';
                AlbumMainController.to.setMode(false);
              }
            });
          },
        )
      ],
    );
  }

  monthBarColumn(albumListController) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          AlbumMainController.to.albumListController
              .refreshAlbumLists(AccountController.to.nickname);
        },
        child:
            (AlbumMainController.to.albumListController.myAlbumLists.length ==
                    0)
                ? Center(
                    child: RaisedButton(
                      child: Text("새로 추가하기"),
                      onPressed: () async {
                        await Get.toNamed("/albumWrite",
                            arguments: AlbumMainController());
                        AlbumMainController.to.albumListController.listResult =
                            AlbumMainController.to
                                .init(AccountController.to.nickname);
                      },
                    ),
                  )
                : AlbumSliverWidget(albumMainController: AlbumMainController.to,
              albumList: AlbumMainController.to.albumListController.myAlbumLists,));
  }
}
//FutureBuilder(
//future: albumListController.listResult,
//builder: (context, snapshot){
//if(snapshot.connectionState == ConnectionState.done){
//return (AlbumMainController.to.albumListController.myAlbumLists.length == 0)
//? Center(
//child: RaisedButton(
//child: Text("새로 추가하기"),
//onPressed: () async {
//await Get.toNamed("/albumWrite",
//arguments: AlbumMainController());
////                    AlbumMainController.to.albumListController.listResult =
////                        AlbumMainController.to.albumListController.init(
////                            AccountController.to.nickname);
//},
//),
//)
//    : AlbumListWidget(
//AlbumMainController.to.albumListController.myAlbumLists,
//AlbumMainController.to);
//}
//if
//(
//snapshot.hasError){
//return Column(
//children: <Widget>[
//Text("오류발생 \n ${snapshot.error.toString()}"),
//RaisedButton(child: Text("확인"))]);
//}
//return
//Center
//(
//child: CircularProgressIndicator
//(
//),);
//},
//)
